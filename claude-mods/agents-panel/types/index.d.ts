export type RunStatus = 'running' | 'done' | 'failed'

export type AgentRun = {
  /** The subagent's id (agent.spawn's agentId), else the Agent call's tool_use_id. */
  id: string
  type: string
  description: string
  model: string
  status: RunStatus
  startedAt: number
  endedAt?: number
  /** Input, output and cache tokens of all its model requests, summed. */
  tokens: number
}

declare module 'claude-code' {
  interface PluginState {
    'agents-panel': {
      runs: AgentRun[]
      now: number
      autoOpened: boolean
    }
  }
}
