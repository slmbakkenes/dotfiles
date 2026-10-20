import type { Skin } from '../skin'

// Gruvbox dark on a dark background, Gruvbox light (the faded accents) on a light one.
const skin: Skin = {
  name: 'gruvbox',
  label: 'Gruvbox',
  palette: {
    read: '#83a598',
    write: '#fe8019',
    run: '#b8bb26',
    search: '#d3869b',
    web: '#8ec07c',
    mcp: '#fabd2f',
    other: '#ebdbb2',
    user: '#fabd2f',
    fg: '#ebdbb2',
    muted: '#928374',
    surface: '#32302f',
    zebra: '#2f2c2a',
    ok: '#b8bb26',
    err: '#fb4934',
    warn: '#fe8019',
  },
  light: {
    read: '#076678',
    write: '#af3a03',
    run: '#79740e',
    search: '#8f3f71',
    web: '#427b58',
    mcp: '#b57614',
    other: '#3c3836',
    user: '#b57614',
    fg: '#3c3836',
    muted: '#7c6f64',
    surface: '#f2e5bc',
    zebra: '#ebdbb2',
    ok: '#79740e',
    err: '#9d0006',
    warn: '#af3a03',
  },
  spinner: ['Brewing', 'Roasting', 'Simmering', 'Toasting', 'Percolating', 'Kindling'],
  done: ['Brewed', 'Roasted', 'Toasted', 'Served'],
}

export default skin
