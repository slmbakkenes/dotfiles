export type Limit = {
  /** `5h`, `7d`, or the engine's own name for any other limit. */
  label: string
  percent: number
  /** Epoch ms of the next reset, when the engine says. */
  resetsAt?: number
}

export type UsageSnap = {
  /** Percent of the context window used; null before the first model request. */
  context: number | null
  /** The context window in tokens. */
  window: number | null
  limits: Limit[]
}

declare module 'claude-code' {
  interface PluginState {
    'usage-panel': {
      usage: UsageSnap
      now: number
    }
  }
}
