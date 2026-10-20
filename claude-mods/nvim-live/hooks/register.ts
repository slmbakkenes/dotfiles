// nvim-live: when Claude Code runs inside Neovim (its terminal sets $NVIM), every
// file edit is played into that Neovim (the file opens in the editor window and
// the new text is typed in, by lua/live.lua), and every file read or written is
// announced as `User ClaudeTouch` for its explorer sidebar.
import type { EngineInterface, Register } from 'claude-code'

const TOUCH: Record<string, 'read' | 'wrote'> = { Read: 'read', Edit: 'wrote', Write: 'wrote', MultiEdit: 'wrote' }

// Module variables: a reload starts them over.
let server = ''
let cwd = ''
let tmp = '/tmp'
let isOn = true
let seq = 0

const env = async ($: EngineInterface, name: string): Promise<string> => {
  const r = await $.process.run(['printenv', name]).catch(() => null)
  return r?.exitCode === 0 ? r.stdout.trim() : ''
}

const vimString = (s: string) => `'${s.replaceAll("'", "''")}'`

const remote = ($: EngineInterface, expr: string) =>
  $.process.run(['nvim', '--server', server, '--remote-expr', expr], { timeoutMs: 5000 }).then(r => {
    if (r.exitCode !== 0) $.ui.log(`nvim-live: ${r.stderr.trim() || `exit ${r.exitCode}`}`, { to: 'debug' })
  })

// `User ClaudeTouch` in nvim, which its explorer sidebar follows.
const touch = ($: EngineInterface, path: string, kind: 'read' | 'wrote') =>
  remote($, `luaeval("vim.api.nvim_exec_autocmds('User', { pattern = 'ClaudeTouch', data = _A })", {'path': ${vimString(path)}, 'kind': '${kind}'})`)

async function send($: EngineInterface, path: string, old: string, text: string): Promise<void> {
  const file = `${tmp.replace(/\/$/, '')}/nvim-live-${Date.now()}-${++seq}.json`
  await $.fs.write(file, JSON.stringify({ path, old, new: text }))
  const lua = `${$.plugin.root}/lua/live.lua`
  const expr = `luaeval('dofile(_A[1]).enqueue(_A[2])', [${vimString(lua)}, ${vimString(file)}])`
  await remote($, expr)
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const r = await next(e)
    cwd = e.cwd
    server = (await env($, 'NVIM_LIVE_SERVER')) || (await env($, 'NVIM'))
    tmp = (await env($, 'TMPDIR')) || tmp
    if (!server) return r
    $.ui.status('nvim live')
    await $.command.register({
      name: 'nvim-live',
      description: 'Play my edits live in the Neovim around this session (toggle)',
      argumentHint: '[on|off]',
      immediate: true,
    })
    return r
  })

  on('command.run', { command: 'nvim-live' }, async ($, e) => {
    const arg = e.args.trim()
    isOn = arg === 'on' ? true : arg === 'off' ? false : !isOn
    $.ui.status(isOn ? 'nvim live' : undefined)
    return { text: `nvim-live ${isOn ? 'on' : 'off'}` }
  })

  on('tool.call', async ($, e, next) => {
    const kind = TOUCH[e.tool]
    const raw = (e as { file_path?: unknown }).file_path
    if (!server || !kind || typeof raw !== 'string') return next(e)
    const path = raw.startsWith('/') ? raw : `${cwd}/${raw}`
    const old = kind === 'wrote' && isOn ? await $.fs.read(path).catch(() => '') : ''
    const r = await next(e)
    if (r.deny !== undefined || r.isError) return r
    await touch($, path, kind).catch(() => {})
    if (kind === 'read' || !isOn) return r
    const text = await $.fs.read(path).catch(() => null)
    if (text !== null && text !== old) {
      await send($, path, old, text).catch(err => $.ui.log(`nvim-live: ${String(err)}`, { to: 'debug' }))
    }
    return r
  }).catch(($, e, next) => next(e))
}
