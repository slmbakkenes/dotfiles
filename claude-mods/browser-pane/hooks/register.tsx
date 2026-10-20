/* @jsx h */
// browser-pane: draws the Homebrew terminal-browser inside a Claude Code pane.
// A lean rewrite of zenbu-labs/terminal-browser's Claude Code plugin (MIT); it
// talks to the same `terminal-browser claude-bridge` server.
import type { EngineInterface, Register } from 'claude-code'
import { MAX_CELLS } from './surface.tsx'
import { inboxLines, isBridgeState, normalizeUrl, parseLaunch, parseMessage, type BridgeState, type Frame } from './bridge.ts'

const PANE = 'browser'
const IMAGE = 'view'
const START_URL = 'terminal-browser://start'

// Module variables: a reload starts them over (and relaunches the bridge on the next /browser).
let bridge: { port: number; token: string } | null = null
let watcher = 0
let isOpen = false
let pendingUrl: string | null = null
let region: { cols: number; rows: number } | null = null
let last: BridgeState | null = null
let frame: Frame | null = null
let mounted: { cols: number; rows: number } | null = null

const source = (f: Frame) => ({ shm: f.shm, format: f.format, width: f.width, height: f.height, generation: f.generation })
const grid = (f: Frame, cols: number, rows: number) => ({
  cols: Math.max(1, Math.min(f.cols, cols, MAX_CELLS)),
  rows: Math.max(1, Math.min(f.rows, rows, MAX_CELLS)),
})

async function call($: EngineInterface, path: string, body?: unknown): Promise<unknown> {
  if (!bridge) return null
  try {
    const res = await $.http.fetch(`http://127.0.0.1:${bridge.port}${path}`, {
      method: body === undefined ? 'GET' : 'POST',
      headers: { 'content-type': 'application/json', authorization: `Bearer ${bridge.token}` },
      ...(body === undefined ? {} : { body: JSON.stringify(body) }),
    })
    return res.ok ? JSON.parse(res.text || '{}') : null
  } catch {
    return null
  }
}

async function launch($: EngineInterface): Promise<string | null> {
  let out = ''
  try {
    const r = await $.process.run(['terminal-browser', 'claude-bridge', 'launch'], { timeoutMs: 20_000 })
    out = r.stdout || `{"error":${JSON.stringify(r.stderr.trim() || `exit ${r.exitCode}`)}}`
  } catch {
    return 'terminal-browser not found: brew install terminal-browser'
  }
  const report = parseLaunch(out)
  if ('error' in report) return `${report.error} (try: terminal-browser upgrade)`
  bridge = report
  void watch($)
  return null
}

// Long-polls the bridge: new frames are blitted into the pane, title changes
// retitle it, and text sent from the browser lands in the prompt.
async function watch($: EngineInterface): Promise<void> {
  const me = ++watcher
  const live = () => watcher === me && bridge !== null
  let version = -1
  while (live()) {
    const raw = await call($, `/state?version=${version}`)
    if (!live()) return
    if (!isBridgeState(raw)) {
      await $.clock.sleep(250)
      continue
    }
    const prev = last
    last = raw
    version = raw.version
    if (raw.inbox > 0) {
      const lines = inboxLines(await call($, '/inbox/take', {}))
      if (lines.length) await $.prompt.fill({ text: `${lines.join('\n')}\n` })
    }
    if (!isOpen) continue
    const gone = !raw.frame && frame !== null
    if (gone) frame = null
    if (!prev || gone || prev.title !== raw.title || prev.alive !== raw.alive || prev.error !== raw.error) {
      $.ui.invalidate('ui.render')
      if (raw.title && prev?.title !== raw.title) await $.ui.open({ id: PANE, title: raw.title.slice(0, 40) })
    }
    const f = raw.frame
    if (!f || f.generation === frame?.generation) continue
    frame = f
    const g = region && grid(f, region.cols, region.rows)
    const fits = g && mounted && g.cols === mounted.cols && g.rows === mounted.rows
    if (!fits || (await $.ui.blit({ requestId: PANE, key: IMAGE, source: source(f) })).deny) {
      $.ui.invalidate('ui.render')
    }
  }
}

async function openBrowser($: EngineInterface, raw: string): Promise<string> {
  if (!bridge) {
    const error = await launch($)
    if (error) return error
  }
  const url = raw ? normalizeUrl(raw) : last?.alive && last.url ? last.url : START_URL
  isOpen = true
  pendingUrl = url
  await $.ui.open({ id: PANE, title: 'browser', focus: true, rows: 24 })
  $.ui.invalidate('ui.render')
  if (region) {
    pendingUrl = null
    await call($, '/open', { url, ...region })
  }
  return `Opened ${url}`
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const r = await next(e)
    const surfaces = await $.session.surfaces().catch(() => [] as readonly string[])
    if (surfaces.includes('terminal')) {
      await $.command.register({
        name: 'browser',
        description: 'Show terminal-browser beside the chat (/browser close to hide)',
        argumentHint: '[url|close]',
        immediate: true,
      })
    }
    return r
  })

  on('command.run', { command: 'browser' }, async ($, e) => {
    const arg = e.args.trim()
    if (arg === 'close' || (!arg && isOpen)) {
      if (isOpen) await $.ui.close({ id: PANE })
      return { text: 'Closed the browser pane' }
    }
    return { text: await openBrowser($, arg) }
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    if (e.surface !== 'terminal') {
      const { Box } = $.ui.resolve(e)
      return <Box />
    }
    const { Box, Client, Image } = $.ui.resolve(e)
    const rows = e.props.scroll.bodyRows > 0 ? e.props.scroll.bodyRows : Math.max(8, (e.viewport?.rows ?? 30) - 8)
    const cols = Math.max(1, e.props.bodyColumns > 0 ? e.props.bodyColumns : (e.viewport?.columns ?? 80))
    const g = frame ? grid(frame, cols, rows) : null
    mounted = g
    return (
      <Box flexDirection="column" width={cols} height={rows}>
        {frame && g ? <Image key={IMAGE} source={source(frame)} columns={g.cols} rows={g.rows} alt="" /> : null}
        <Box position="absolute" top={0} left={0} width={cols} height={rows}>
          <Client key="input" module="./surface.tsx" width={cols} height={rows} />
        </Box>
      </Box>
    )
  })

  on('ui.message', async ($, e, next) => {
    const msg = e.requestId === PANE && bridge ? parseMessage(e.data) : null
    if (msg?.type === 'size') {
      region = { cols: msg.cols, rows: msg.rows }
      const url = pendingUrl
      pendingUrl = null
      await call($, url ? '/open' : '/size', url ? { url, ...region } : region)
    } else if (msg?.type === 'input') {
      await call($, '/input', { events: msg.events })
    }
    return next(e)
  })

  on('ui.scroll', { requestId: PANE }, async ($, e) => {
    if (!bridge || !isOpen || e.by === 0) return {}
    const kind = e.by < 0 ? 'scrollup' : 'scrolldown'
    const x = e.pointer?.column ?? Math.floor((region?.cols ?? 0) / 2)
    const y = e.pointer?.row ?? Math.floor((region?.rows ?? 0) / 2)
    const ticks = Math.min(Math.round(Math.abs(e.by)) || 1, 10)
    void call($, '/input', { events: Array.from({ length: ticks }, () => ({ type: 'mouse', kind, x, y })) })
    return {}
  })

  on('ui.close', { id: PANE }, async ($, e, next) => {
    const r = await next(e)
    isOpen = false
    pendingUrl = region = frame = mounted = null
    void call($, '/browser/close', {})
    return r
  })
}
