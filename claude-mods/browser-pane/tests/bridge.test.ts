import { expect, test } from 'claude-code/testing'
import { inboxLines, isBridgeState, normalizeUrl, parseLaunch, parseMessage } from '../hooks/bridge.ts'

test('normalizeUrl', async () => {
  expect(normalizeUrl(' example.com ')).toBe('https://example.com')
  expect(normalizeUrl('localhost:3000/x')).toBe('http://localhost:3000/x')
  expect(normalizeUrl('127.0.0.1:8080')).toBe('http://127.0.0.1:8080')
  expect(normalizeUrl('/tmp/page.html')).toBe('file:///tmp/page.html')
  expect(normalizeUrl('https://a.dev')).toBe('https://a.dev')
  expect(normalizeUrl('terminal-browser://start')).toBe('terminal-browser://start')
})

test('parseLaunch', async () => {
  expect(parseLaunch('noise\n{"port":4100,"token":"t"}\n')).toEqual({ port: 4100, token: 't' })
  expect(parseLaunch('{"error":"no tty","code":"tty"}')).toEqual({ error: 'no tty' })
  expect('error' in parseLaunch('garbage')).toBe(true)
})

test('messages, state and inbox', async () => {
  expect(parseMessage({ type: 'size', cols: 80, rows: 24 })).toEqual({ type: 'size', cols: 80, rows: 24 })
  expect(parseMessage({ type: 'size', cols: 'x', rows: 24 })).toBe(null)
  expect(isBridgeState({ version: 1, alive: true, frame: null })).toBe(true)
  expect(isBridgeState({ version: 1, alive: true, frame: { shm: 'x' } })).toBe(false)
  expect(inboxLines({ items: [{ text: 'look\nhere', screenshot: '/tmp/s.png' }, { text: ' ' }] }))
    .toEqual(['look here', '/tmp/s.png'])
})

test('/browser registers on a terminal and close is a no-op when nothing is open', async ($, on) => {
  const names: string[] = []
  on('command.register', (_, e) => { names.push(e.name); return { value: { command: e.name } } })
  on('session.surfaces', () => ({ value: ['terminal'] }))
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  expect(names).toEqual(['browser'])
  const r = await $.command.run({ command: 'browser', args: 'close', origin: { kind: 'composer' }, presentation: { isFullscreen: true, columns: 160 } })
  expect(r.text).toBe('Closed the browser pane')
})
