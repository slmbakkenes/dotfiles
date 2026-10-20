import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { AgentRun } from '../types'

const PANE = 'agents-panel'
const TITLE = 'Agents'
const MAX_RUNS = 100

const runs = atom({ plugin: 'agents-panel', key: 'runs' } as const, [])
const now = atom({ plugin: 'agents-panel', key: 'now' } as const, 0)
const autoOpened = atom({ plugin: 'agents-panel', key: 'autoOpened' } as const, false)

const GLYPH = { running: '●', done: '✓', failed: '✗' } as const
const COLOR = { running: 'yellow', done: 'green', failed: 'red' } as const

// "claude-opus-5-5" -> "Opus 5.5", "sonnet" -> "Sonnet"; anything else as given.
const modelName = (id: string): string => {
  const m = /(fable|mythos|opus|sonnet|haiku)(?:-(\d+)(?:-(\d{1,2})(?!\d))?)?/i.exec(id)
  if (!m) return id.replace(/^claude-/, '').replace(/\[.*\]$/, '') || '?'
  const [, family = '', major, minor] = m
  const name = family.charAt(0).toUpperCase() + family.slice(1).toLowerCase()
  return major ? `${name} ${major}${minor ? '.' + minor : ''}` : name
}

const fmtTime = (ms: number): string => {
  const s = Math.max(0, Math.round(ms / 1000))
  if (s < 60) return `${s}s`
  const m = Math.floor(s / 60)
  if (m < 60) return `${m}m ${String(s % 60).padStart(2, '0')}s`
  return `${Math.floor(m / 60)}h ${String(m % 60).padStart(2, '0')}m`
}

const fmtTokens = (n: number): string =>
  n >= 1e6 ? `${(n / 1e6).toFixed(1)}M` : n >= 1e3 ? `${Math.round(n / 1e3)}k` : `${n}`

type Usage = {
  input_tokens: number
  output_tokens: number
  cache_read_input_tokens: number
  cache_creation_input_tokens: number
}
const sum = (u: Usage): number =>
  (u.input_tokens || 0) + (u.output_tokens || 0) + (u.cache_read_input_tokens || 0) + (u.cache_creation_input_tokens || 0)

const patch = ($: EngineInterface, id: string, fn: (run: AgentRun) => AgentRun) =>
  update($, runs, list => list.map(run => (run.id === id ? fn(run) : run)))

const open = ($: EngineInterface) => $.ui.open({ id: PANE, title: TITLE })

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const started = await next(e)
    await $.command.register({ name: 'agents-panel', description: "Show or hide the pane with this session's subagents" })
    // Ticks the elapsed time of running agents; does nothing while none run.
    $.clock.every(1000, async () => {
      if (!(await read($, runs)).some(run => run.status === 'running')) return
      const at = await $.clock.now()
      await update($, now, () => at)
    })
    return started
  })

  on('command.run', { command: 'agents-panel' }, async $ => {
    if ((await $.ui.panes()).some(pane => pane.id === PANE)) {
      await $.ui.close({ id: PANE })
      return { text: 'Agents panel closed.' }
    }
    const at = await $.clock.now()
    await update($, now, () => at)
    await open($)
    return { text: 'Agents panel opened.' }
  })

  on('agent.spawn', async ($, e, next) => {
    const started = await next(e)
    if (started.deny !== undefined) return started

    const at = await $.clock.now()
    const id = started.agentId ?? e.tool_use_id
    await update($, runs, list => {
      const prev = list.find(run => run.id === id)
      const run: AgentRun = {
        id,
        type: e.subagentType || 'agent',
        description: e.description,
        model: started.model || e.model || e.parentModel,
        status: 'running',
        startedAt: prev?.startedAt ?? at,
        tokens: prev?.tokens ?? 0,
      }
      return [...list.filter(one => one.id !== id), run].slice(-MAX_RUNS)
    })
    await update($, now, () => at)

    // Once per session, on the first subagent; the engine seats it only when the terminal is wide enough.
    if (!(await read($, autoOpened))) {
      await update($, autoOpened, () => true)
      void open($)
    }
    return started
  })

  // Each model request of a subagent: running token count and the model it really ran on.
  on('turn.step', async function* ($, e, next) {
    const result = yield* next(e)
    const usage = result.usage
    const agentId = e.agentId
    if (agentId && usage) {
      await patch($, agentId, run => ({ ...run, model: usage.model || e.model || run.model, tokens: run.tokens + sum(usage) }))
    }
    return result
  })

  on('turn.complete', async ($, e, next) => {
    const agentId = e.agentId
    if (agentId) {
      const at = await $.clock.now()
      await patch($, agentId, run => ({
        ...run,
        status: e.reason === 'answer' ? 'done' : 'failed',
        endedAt: at,
        // A turn whose steps went unseen still gets its own sum.
        tokens: run.tokens || (e.usage ? sum(e.usage) : 0),
      }))
      await update($, now, () => at)
    }
    return next(e)
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    const list = await read($, runs)
    const at = Math.max(await read($, now), ...list.map(run => run.endedAt ?? run.startedAt))

    const running = list.filter(run => run.status === 'running')
    const finished = list
      .filter(run => run.status !== 'running')
      .sort((a, b) => (b.endedAt ?? 0) - (a.endedAt ?? 0))
    const total = list.reduce((n, run) => n + run.tokens, 0)

    const row = (run: AgentRun) => (
      <Box key={run.id} flexDirection="column" marginBottom={1}>
        <Box flexDirection="row" justifyContent="space-between" gap={1}>
          <Text wrap="truncate-end">
            <Text color={COLOR[run.status]}>{GLYPH[run.status]}</Text> <Text bold>{run.type}</Text>
            <Text dimColor> · </Text>
            <Text color="cyan">{modelName(run.model)}</Text>
          </Text>
          <Text dimColor>{fmtTime((run.endedAt ?? at) - run.startedAt)}</Text>
        </Box>
        <Text dimColor wrap="truncate-end">
          {'  '}
          {run.description || '—'}
          {run.tokens ? ` · ${fmtTokens(run.tokens)} tok` : ''}
          {run.status === 'failed' ? ' · failed' : ''}
        </Text>
      </Box>
    )

    if (list.length === 0) return <Text dimColor>No subagents yet.</Text>

    return (
      <Box flexDirection="column">
        <Text dimColor wrap="truncate-end">
          {running.length} running · {finished.length} finished{total ? ` · ${fmtTokens(total)} tokens` : ''}
        </Text>
        <Box flexDirection="column" marginTop={1}>
          {running.map(row)}
          {running.length > 0 && finished.length > 0 && <Text dimColor>Finished</Text>}
          {finished.map(row)}
        </Box>
      </Box>
    )
  })
}
