// Wire format of `terminal-browser claude-bridge` (a localhost HTTP server).
// Protocol details taken from zenbu-labs/terminal-browser's Claude Code plugin, MIT licensed.

export type Frame = {
  shm: string
  format: 'rgba' | 'rgb'
  width: number
  height: number
  generation: number
  cols: number
  rows: number
}

export type BridgeState = {
  version: number
  frame: Frame | null
  title: string
  url: string | null
  alive: boolean
  error: string | null
  inbox: number
}

const isRecord = (v: unknown): v is Record<string, any> => typeof v === 'object' && v !== null
const isInt = Number.isInteger

const isFrame = (v: unknown): v is Frame =>
  isRecord(v) && typeof v.shm === 'string' && (v.format === 'rgba' || v.format === 'rgb')
  && [v.width, v.height, v.generation, v.cols, v.rows].every(isInt)

export const isBridgeState = (v: unknown): v is BridgeState =>
  isRecord(v) && isInt(v.version) && typeof v.alive === 'boolean' && (v.frame === null || isFrame(v.frame))

/** `{port, token}` from `claude-bridge launch`, or the error it printed. */
export function parseLaunch(stdout: string): { port: number; token: string } | { error: string } {
  const line = stdout.split('\n').find(l => l.startsWith('{'))
  try {
    const r: unknown = line ? JSON.parse(line) : null
    if (isRecord(r) && typeof r.port === 'number' && typeof r.token === 'string') return { port: r.port, token: r.token }
    if (isRecord(r) && typeof r.error === 'string') return { error: r.error }
  } catch {}
  return { error: 'terminal-browser could not start' }
}

export type Message =
  | { type: 'size'; cols: number; rows: number }
  | { type: 'input'; events: unknown[] }

export const parseMessage = (d: unknown): Message | null =>
  isRecord(d) && d.type === 'size' && isInt(d.cols) && isInt(d.rows) ? { type: 'size', cols: d.cols, rows: d.rows }
  : isRecord(d) && d.type === 'input' && Array.isArray(d.events) ? { type: 'input', events: d.events }
  : null

/** Text the person sent from the browser to Claude (`/inbox/take`), one line per item. */
export const inboxLines = (v: unknown): string[] => {
  const oneLine = (t: string) => t.replace(/[\x00-\x1f\x7f-\x9f]/g, ' ').replace(/\s+/g, ' ').trim()
  const items = isRecord(v) && Array.isArray(v.items) ? v.items : []
  return items
    .filter((i: unknown) => isRecord(i) && typeof i.text === 'string' && i.text.trim() !== '')
    .flatMap((i: any) => [oneLine(i.text), ...(typeof i.screenshot === 'string' ? [oneLine(i.screenshot)] : [])])
}

export function normalizeUrl(raw: string): string {
  const t = raw.trim()
  if (t.startsWith('/')) return `file://${t}`
  if (/^[a-z][a-z0-9+.-]*:/i.test(t) && !/^localhost:/i.test(t)) return t
  if (/^(localhost|\d+\.\d+\.\d+\.\d+)(:\d+)?(\/|$)/i.test(t)) return `http://${t}`
  return `https://${t}`
}
