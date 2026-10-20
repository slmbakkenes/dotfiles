import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { UsageSnap } from '../types'

const PANE = 'usage-panel'
const TITLE = 'Usage'
const BAR = 16
const MINUTE_MS = 60_000

const usage = atom({ plugin: 'usage-panel', key: 'usage' } as const, { context: null, window: null, limits: [] } as UsageSnap)
const now = atom({ plugin: 'usage-panel', key: 'now' } as const, 0)

// Calm while there is room; yellow from 80 %, red from 95 %.
const color = (percent: number): string => (percent >= 95 ? 'red' : percent >= 80 ? 'yellow' : 'green')

const bar = (percent: number): string => {
  const filled = Math.round((percent / 100) * BAR)
  return '▰'.repeat(filled) + '▱'.repeat(BAR - filled)
}

// `five_hour` reads as `5h`, `seven_day` as `7d`; any other kind as its own name.
const labelOf = (kind: string): string => {
  const name = kind.toLowerCase()
  if (name.includes('five') || name.includes('5h') || name.includes('5_h')) return '5h'
  if (name.includes('seven') || name.includes('7d') || name.includes('week')) return '7d'
  return name.replace(/_/g, ' ')
}

const NAMES: Record<string, string> = { '5h': 'Session (5h)', '7d': 'Week (7d)' }

// The time left until a reset, to the minute: `3d 4h`, `1h 05m`, `12m`, and `now` once it is due.
const countdown = (ms: number): string => {
  const minutes = Math.ceil(ms / MINUTE_MS)
  if (minutes <= 0) return 'now'
  const days = Math.floor(minutes / 1440)
  const hours = Math.floor((minutes % 1440) / 60)
  const rest = minutes % 60
  if (days > 0) return `${days}d ${hours}h`
  return hours > 0 ? `${hours}h ${String(rest).padStart(2, '0')}m` : `${rest}m`
}

const DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

// The reset as a wall-clock time, with the weekday when it is not today.
const clockTime = (at: number, from: number): string => {
  const date = new Date(at)
  const time = `${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`
  return new Date(from).toDateString() === date.toDateString() ? time : `${DAYS[date.getDay()]} ${time}`
}

const fmtTokens = (n: number): string => (n >= 1e6 ? `${(n / 1e6).toFixed(1)}M` : n >= 1e3 ? `${Math.round(n / 1e3)}k` : `${n}`)

const clamp = (percent: number): number => Math.max(0, Math.min(100, Math.round(percent)))

async function refresh($: EngineInterface): Promise<void> {
  const measured = await $.session.usage()
  const snap: UsageSnap = {
    context: measured.context.percent ?? null,
    window: measured.context.window ?? null,
    limits: measured.rateLimits.map(limit => {
      const resetsAt = limit.resetsAt === undefined ? NaN : Date.parse(limit.resetsAt)
      return { label: labelOf(limit.kind), percent: limit.percentUsed, ...(Number.isNaN(resetsAt) ? {} : { resetsAt }) }
    }),
  }
  const at = await $.clock.now()
  await update($, usage, () => snap)
  await update($, now, () => at)
}

const open = ($: EngineInterface) => $.ui.open({ id: PANE, title: TITLE })

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const started = await next(e)
    await $.command.register({ name: 'usage-panel', description: 'Show or hide the pane with context and plan usage' })
    await refresh($).catch((error: unknown) => $.ui.log(`usage: ${error instanceof Error ? error.message : String(error)}`, { to: 'debug' }))
    // Keeps the countdowns to the minute; the numbers change on measure and turn end.
    $.clock.every(MINUTE_MS, async () => {
      const at = await $.clock.now()
      await update($, now, () => at)
    })
    void open($)
    return started
  })

  on('command.run', { command: 'usage-panel' }, async $ => {
    if ((await $.ui.panes()).some(pane => pane.id === PANE)) {
      await $.ui.close({ id: PANE })
      return { text: 'Usage panel closed.' }
    }
    await refresh($)
    await open($)
    return { text: 'Usage panel opened.' }
  })

  on('session.measure', async ($, e, next) => {
    await refresh($)
    return next(e)
  })

  on('turn.complete', async ($, e, next) => {
    if (e.agentId === undefined) await refresh($)
    return next(e)
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    const snap = await read($, usage)
    const at = await read($, now)

    const meter = (key: string, name: string, percent: number, detail: string | undefined) => {
      const shown = clamp(percent)
      return (
        <Box key={key} flexDirection="column" marginBottom={1}>
          <Box flexDirection="row" justifyContent="space-between" gap={1}>
            <Text bold>{name}</Text>
            <Text color={color(shown)}>{shown}%</Text>
          </Box>
          <Text color={color(shown)}>{bar(shown)}</Text>
          {detail !== undefined && (
            <Text dimColor wrap="truncate-end">
              {detail}
            </Text>
          )}
        </Box>
      )
    }

    const contextLeft =
      snap.context === null || snap.window === null ? undefined : `${fmtTokens(Math.max(0, Math.round(snap.window * (1 - snap.context / 100))))} of ${fmtTokens(snap.window)} left`

    if (snap.context === null && snap.limits.length === 0) return <Text dimColor>No usage measured yet.</Text>

    return (
      <Box flexDirection="column">
        {snap.context !== null && meter('context', 'Context', snap.context, contextLeft)}
        {snap.limits.map(limit =>
          meter(
            limit.label,
            NAMES[limit.label] ?? limit.label,
            limit.percent,
            limit.resetsAt === undefined ? undefined : `resets in ${countdown(limit.resetsAt - at)} · ${clockTime(limit.resetsAt, at)}`,
          ),
        )}
      </Box>
    )
  })
}
