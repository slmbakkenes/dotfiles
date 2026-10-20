/* @jsx h */
// Client module drawn over the browser image: reports the pane's size and
// forwards keys and pointer events to the bridge (format from zenbu-labs/terminal-browser, MIT).
import type { ClientKeyEvent, ClientPointerEvent, ClientSurface } from 'claude-code'

export const MAX_CELLS = 255

type Mods = { shift: boolean; alt: boolean; ctrl: boolean; super: boolean }
type Input =
  | { type: 'mouse'; kind: string; button?: string; x: number; y: number; mods: Mods }
  | { type: 'key'; key: string; text?: string; mods: Mods }

const NAMED = new Set(['enter', 'backspace', 'delete', 'tab', 'up', 'down', 'left', 'right', 'home', 'end', 'pageup', 'pagedown', 'insert'])

function key(e: ClientKeyEvent): Input | null {
  const mods = { shift: !!e.shift, alt: false, ctrl: !!e.ctrl, super: !!e.meta }
  const lower = e.key.toLowerCase()
  const name = lower === 'return' ? 'enter' : lower === 'space' ? ' ' : NAMED.has(lower) ? lower : null
  const plain = !mods.ctrl && !mods.super
  if (name) return { type: 'key', key: name, text: name === ' ' && plain ? ' ' : undefined, mods }
  if ([...e.key].length === 1) return { type: 'key', key: e.key, text: plain ? e.key : undefined, mods }
  return /^f\d{1,2}$/i.test(e.key) ? { type: 'key', key: lower, mods } : null
}

function pointer(e: ClientPointerEvent): Input {
  const mods = { shift: !!e.shift, alt: !!e.alt, ctrl: !!e.ctrl, super: false }
  const kind = e.type === 'enter' || e.type === 'leave' ? 'move' : e.type
  return { type: 'mouse', kind, button: e.button, x: e.x, y: e.y, mods }
}

export default function Browser(_props: unknown, surface: ClientSurface<{ cols: number; rows: number }>) {
  if (surface.state === undefined) {
    const queue: Input[] = []
    surface.setState({ cols: 0, rows: 0 })
    surface.onPointer(e => queue.push(pointer(e)))
    surface.onKey(e => { const k = key(e); if (k) queue.push(k) })
    surface.every(20, () => {
      if (queue.length) surface.post({ type: 'input', events: queue.splice(0) as never })
    })
  }
  const cols = Math.min(surface.columns, MAX_CELLS)
  const rows = Math.min(surface.rows, MAX_CELLS)
  const s = surface.state
  if (cols > 0 && rows > 0 && s && (s.cols !== cols || s.rows !== rows)) {
    surface.setState({ cols, rows })
    surface.post({ type: 'size', cols, rows })
  }
  const { Box } = surface.elements
  return <Box flexDirection="column" height="100%" />
}
