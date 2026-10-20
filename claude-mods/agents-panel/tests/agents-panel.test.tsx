import { expect, mock, test } from 'claude-code/testing'

const PANE = {
  plugin: 'agents-panel',
  component: 'Pane',
  requestId: 'agents-panel',
  props: {
    title: 'Agents',
    isFocused: false,
    bodyColumns: 48,
    placement: 'dock',
    scroll: { offset: 0, bodyRows: 30 },
    view: {},
  },
} as const

const spawn = (subagentType: string, description: string) => ({
  tool_use_id: `tu-${description}`,
  prompt: description,
  description,
  subagentType,
  provider: { plugin: 'engine', tier: 'core' } as const,
  parentModel: 'claude-opus-5-5',
  background: false,
  fork: false,
})

const usage = { input_tokens: 1000, output_tokens: 500, cache_read_input_tokens: 40000, cache_creation_input_tokens: 0 }

test('lists running agents first, with type, model, time and tokens; opens once', async ($, on) => {
  const clock = mock.clock(on, { now: 1_000_000 })
  const opened: string[] = []
  on('command.register', () => ({ value: { command: 'agents-panel' } }))
  on('ui.open', (_, e) => (opened.push(e.id), { value: { isPlaced: true } }))
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  // Stands for the engine: each spawn starts an agent on the model its type names.
  let n = 0
  on('agent.spawn', (_, e) => ({
    agentId: `a${++n}`,
    model: e.subagentType === 'story-planner' ? 'claude-opus-5-5' : 'claude-sonnet-5-5',
  }))
  on('turn.complete', () => ({ text: '' }))

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await $.agent.spawn(spawn('story-planner', 'Plan story 10565'))
  await clock.advance(65_000)
  await $.agent.spawn(spawn('devops', 'Create tasks'))
  await clock.advance(10_000)
  await $.turn.complete({ agentId: 'a2', reason: 'answer', answer: 'ok', durationMs: 10_000, isAborted: false, turnId: 't2', usage: { ...usage, model: 'claude-sonnet-5-5' } })
  await clock.advance(5_000)

  expect(opened).toEqual(['agents-panel'])

  for (const surface of ['terminal', 'desktop', 'vscode', 'mobile'] as const) {
    const ui = await $.ui.mount({ ...PANE, surface })
    const texts = (await ui.findAll({ type: 'Text' })).map(t => t.text)
    expect(texts).toContain('1 running · 1 finished · 42k tokens')
    const planner = texts.findIndex(t => /story-planner · Opus 5\.5/.test(t ?? ''))
    const devops = texts.findIndex(t => /devops · Sonnet 5\.5/.test(t ?? ''))
    expect(planner).toBeGreaterThan(-1)
    expect(devops).toBeGreaterThan(planner)
    expect(texts).toContain('1m 20s')
    expect(texts).toContain('10s')
    expect(texts.some(t => /Create tasks · 42k tok/.test(t ?? ''))).toBe(true)
    await ui.unmount()
  }
})

test('the command toggles the pane', async ($, on) => {
  mock.clock(on)
  const panes: string[] = []
  on('ui.open', (_, e) => (panes.push(e.id), { value: { isPlaced: true } }))
  on('ui.close', (_, e) => (panes.splice(panes.indexOf(e.id), 1), { value: undefined }))
  on('ui.panes', () => ({ value: panes.map(id => ({ id, isPlaced: true })) }) as never)

  expect(await $.command.run({ command: 'agents-panel', args: '' } as never)).toMatchObject({ text: 'Agents panel opened.' })
  expect(await $.command.run({ command: 'agents-panel', args: '' } as never)).toMatchObject({ text: 'Agents panel closed.' })
})
