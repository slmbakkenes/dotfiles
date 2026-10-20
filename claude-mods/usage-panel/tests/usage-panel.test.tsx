import { expect, mock, test } from 'claude-code/testing'

const PANE = {
  plugin: 'usage-panel',
  component: 'Pane',
  requestId: 'usage-panel',
  props: {
    title: 'Usage',
    isFocused: false,
    bodyColumns: 40,
    placement: 'dock',
    scroll: { offset: 0, bodyRows: 30 },
    view: {},
  },
} as const

const START = Date.UTC(2026, 9, 20, 10, 0)

test('shows context left and each limit with its reset; opens at start', async ($, on) => {
  const clock = mock.clock(on, { now: START })
  const opened: string[] = []
  let five = 27
  on('command.register', () => ({ value: { command: 'usage-panel' } }))
  on('ui.open', (_, e) => (opened.push(e.id), { value: { isPlaced: true } }))
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  on('session.usage', () => ({
    value: {
      startedAt: 0,
      context: { window: 200000, percent: 12 },
      rateLimits: [
        { kind: 'five_hour', percentUsed: five, resetsAt: new Date(START + 65 * 60_000).toISOString() },
        { kind: 'seven_day', percentUsed: 96, resetsAt: new Date(START + 4 * 86_400_000).toISOString() },
      ],
    },
  }))
  on('turn.complete', () => ({ text: '' }))

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  expect(opened).toEqual(['usage-panel'])

  for (const surface of ['terminal', 'desktop'] as const) {
    const ui = await $.ui.mount({ ...PANE, surface })
    const texts = (await ui.findAll({ type: 'Text' })).map(t => t.text)
    expect(texts).toContain('Context')
    expect(texts).toContain('176k of 200k left')
    expect(texts).toContain('Session (5h)')
    expect(texts).toContain('resets in 1h 05m · ' + new Date(START + 65 * 60_000).toTimeString().slice(0, 5))
    expect(texts).toContain('Week (7d)')
    expect(texts.some(t => /^resets in 4d 0h · \w{3} \d\d:\d\d$/.test(t ?? ''))).toBe(true)
    expect(((await ui.find({ type: 'Text', text: '96%' })) as { props: { color?: string } }).props.color).toBe('red')
    await ui.unmount()
  }

  // The countdown ticks with the clock; the numbers follow the turn's end.
  await clock.advance(60_000)
  five = 31
  await $.turn.complete({ reason: 'answer', answer: 'ok', durationMs: 1, isAborted: false, turnId: 't1' } as never)
  const ui = await $.ui.mount({ ...PANE, surface: 'terminal' })
  const texts = (await ui.findAll({ type: 'Text' })).map(t => t.text)
  expect(texts).toContain('31%')
  expect(texts.some(t => /^resets in 1h 04m/.test(t ?? ''))).toBe(true)
})

test('says so before anything is measured', async ($, on) => {
  mock.clock(on, { now: START })
  on('command.register', () => ({ value: { command: 'usage-panel' } }))
  on('ui.open', () => ({ value: { isPlaced: true } }))
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  on('session.usage', () => ({ value: { startedAt: 0, context: { window: 200000 }, rateLimits: [] } }) as never)

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  const ui = await $.ui.mount({ ...PANE, surface: 'terminal' })
  expect(await ui.find({ type: 'Text', text: 'No usage measured yet.' })).toBeDefined()
})

test('the command toggles the pane', async ($, on) => {
  mock.clock(on)
  const panes: string[] = []
  on('session.usage', () => ({ value: { startedAt: 0, context: { window: 200000, percent: 5 }, rateLimits: [] } }))
  on('ui.open', (_, e) => (panes.push(e.id), { value: { isPlaced: true } }))
  on('ui.close', (_, e) => (panes.splice(panes.indexOf(e.id), 1), { value: undefined }))
  on('ui.panes', () => ({ value: panes.map(id => ({ id, isPlaced: true })) }) as never)

  expect(await $.command.run({ command: 'usage-panel', args: '' } as never)).toMatchObject({ text: 'Usage panel opened.' })
  expect(await $.command.run({ command: 'usage-panel', args: '' } as never)).toMatchObject({ text: 'Usage panel closed.' })
})
