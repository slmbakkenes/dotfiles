-- Renoir colorscheme palette
-- All colors defined here for easy customization

local M = {}

M.colors = {
  -- Backgrounds
  bg = "#1A1410",           -- deep warm black (main background)
  bg_dark = "#0F0C09",      -- darkest shadow (sidebars, floats)
  bg_highlight = "#3D2E1F", -- dark amber (current line, visual)
  bg_search = "#C5A572",    -- antique gold (search highlight)
  bg_visual = "#3D2E1F",    -- dark amber (visual selection)

  -- Foregrounds
  fg = "#E8D5B7",           -- warm parchment (main text)
  fg_dark = "#DEB887",      -- burlywood (secondary text)
  fg_gutter = "#8B7355",    -- warm taupe (line numbers, comments)
  border = "#6B4423",       -- deep russet (window borders)

  -- Syntax (warm spectrum)
  gold = "#D4A574",         -- warm gold (functions, methods)
  amber = "#E6B17E",        -- soft amber (types, classes)
  sienna = "#CD853F",       -- peru/sienna (constants, numbers)
  rust = "#B8734A",         -- rusty orange (keywords)
  copper = "#C47F5A",       -- copper (operators)

  -- Syntax (earth tones for contrast)
  sage = "#A9B78A",         -- muted sage green (strings)
  moss = "#8B9D6A",         -- moss green (string escape sequences)
  stone = "#9CA0A8",        -- cool stone gray (punctuation, brackets)
  clay = "#C19A6B",         -- clay/camel (variables)
  umber = "#8B6C42",        -- raw umber (tags, attributes)

  -- Semantic colors (diagnostics)
  error = "#D46A6A",        -- muted terracotta red
  warning = "#D4A04A",      -- golden yellow
  info = "#7AB0C4",         -- dusty teal blue
  hint = "#A9B78A",         -- sage green
  success = "#7D9B6A",      -- olive green

  -- Special
  purple = "#B39DBC",       -- dusty lavender (special keywords, decorators)
  blue = "#7CA3B7",         -- slate blue (links, references)

  -- Git
  git_add = "#7D9B6A",
  git_change = "#D4A04A",
  git_delete = "#D46A6A",

  -- Diff backgrounds
  diff_add = "#2a3a2a",
  diff_change = "#3a3520",
  diff_delete = "#3a2525",
  diff_text = "#4a4525",

  -- Utility
  none = "NONE",
}

return M
