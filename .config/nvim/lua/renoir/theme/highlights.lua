-- Renoir colorscheme highlight definitions

local M = {}

function M.setup(c, hl)
  -----------------------------------------------------------------------------
  -- Editor UI
  -----------------------------------------------------------------------------
  hl(0, "Normal", { fg = c.fg, bg = c.bg })
  hl(0, "NormalFloat", { fg = c.fg, bg = c.bg_dark })
  hl(0, "NormalNC", { fg = c.fg, bg = c.bg })
  hl(0, "Cursor", { fg = c.bg, bg = c.fg })
  hl(0, "CursorLine", { bg = c.bg_highlight })
  hl(0, "CursorColumn", { bg = c.bg_highlight })
  hl(0, "ColorColumn", { bg = c.bg_highlight })
  hl(0, "LineNr", { fg = c.fg_gutter })
  hl(0, "CursorLineNr", { fg = c.gold, bold = true })
  hl(0, "SignColumn", { fg = c.fg_gutter, bg = c.bg })
  hl(0, "VertSplit", { fg = c.border })
  hl(0, "WinSeparator", { fg = c.border })
  hl(0, "Folded", { fg = c.fg_gutter, bg = c.bg_highlight })
  hl(0, "FoldColumn", { fg = c.fg_gutter, bg = c.bg })
  hl(0, "NonText", { fg = c.fg_gutter })
  hl(0, "SpecialKey", { fg = c.fg_gutter })
  hl(0, "EndOfBuffer", { fg = c.bg })
  hl(0, "Conceal", { fg = c.fg_gutter })

  -----------------------------------------------------------------------------
  -- Popup Menus and Floats
  -----------------------------------------------------------------------------
  hl(0, "Pmenu", { fg = c.fg, bg = c.bg_dark })
  hl(0, "PmenuSel", { fg = c.fg, bg = c.bg_highlight })
  hl(0, "PmenuSbar", { bg = c.bg_highlight })
  hl(0, "PmenuThumb", { bg = c.fg_gutter })
  hl(0, "FloatBorder", { fg = c.border, bg = c.bg_dark })
  hl(0, "FloatTitle", { fg = c.gold, bg = c.bg_dark, bold = true })

  -----------------------------------------------------------------------------
  -- Search and Selection
  -----------------------------------------------------------------------------
  hl(0, "Visual", { bg = c.bg_visual })
  hl(0, "VisualNOS", { bg = c.bg_visual })
  hl(0, "Search", { fg = c.bg, bg = c.bg_search })
  hl(0, "IncSearch", { fg = c.bg, bg = c.gold })
  hl(0, "CurSearch", { fg = c.bg, bg = c.amber })
  hl(0, "Substitute", { fg = c.bg, bg = c.rust })
  hl(0, "MatchParen", { fg = c.amber, bold = true })

  -----------------------------------------------------------------------------
  -- Status Line and Tab Line
  -----------------------------------------------------------------------------
  hl(0, "StatusLine", { fg = c.fg, bg = c.bg_dark })
  hl(0, "StatusLineNC", { fg = c.fg_gutter, bg = c.bg_dark })
  hl(0, "TabLine", { fg = c.fg_gutter, bg = c.bg_dark })
  hl(0, "TabLineFill", { bg = c.bg_dark })
  hl(0, "TabLineSel", { fg = c.fg, bg = c.bg_highlight })
  hl(0, "WinBar", { fg = c.fg, bg = c.bg })
  hl(0, "WinBarNC", { fg = c.fg_gutter, bg = c.bg })

  -----------------------------------------------------------------------------
  -- Messages and Prompts
  -----------------------------------------------------------------------------
  hl(0, "MsgArea", { fg = c.fg })
  hl(0, "ModeMsg", { fg = c.fg, bold = true })
  hl(0, "MoreMsg", { fg = c.sage })
  hl(0, "Question", { fg = c.sage })
  hl(0, "ErrorMsg", { fg = c.error })
  hl(0, "WarningMsg", { fg = c.warning })
  hl(0, "Title", { fg = c.gold, bold = true })
  hl(0, "Directory", { fg = c.gold })

  -----------------------------------------------------------------------------
  -- Core Syntax
  -----------------------------------------------------------------------------
  hl(0, "Comment", { fg = c.fg_gutter, italic = true })
  hl(0, "Constant", { fg = c.sienna })
  hl(0, "String", { fg = c.sage })
  hl(0, "Character", { fg = c.sage })
  hl(0, "Number", { fg = c.sienna })
  hl(0, "Boolean", { fg = c.sienna })
  hl(0, "Float", { fg = c.sienna })

  hl(0, "Identifier", { fg = c.clay })
  hl(0, "Function", { fg = c.gold })

  hl(0, "Statement", { fg = c.rust })
  hl(0, "Conditional", { fg = c.rust })
  hl(0, "Repeat", { fg = c.rust })
  hl(0, "Label", { fg = c.rust })
  hl(0, "Operator", { fg = c.copper })
  hl(0, "Keyword", { fg = c.rust })
  hl(0, "Exception", { fg = c.rust })

  hl(0, "PreProc", { fg = c.purple })
  hl(0, "Include", { fg = c.purple })
  hl(0, "Define", { fg = c.purple })
  hl(0, "Macro", { fg = c.purple })
  hl(0, "PreCondit", { fg = c.purple })

  hl(0, "Type", { fg = c.amber })
  hl(0, "StorageClass", { fg = c.rust })
  hl(0, "Structure", { fg = c.amber })
  hl(0, "Typedef", { fg = c.amber })

  hl(0, "Special", { fg = c.copper })
  hl(0, "SpecialChar", { fg = c.moss })
  hl(0, "Tag", { fg = c.umber })
  hl(0, "Delimiter", { fg = c.stone })
  hl(0, "SpecialComment", { fg = c.fg_gutter, bold = true })
  hl(0, "Debug", { fg = c.warning })

  hl(0, "Underlined", { underline = true })
  hl(0, "Ignore", { fg = c.fg_gutter })
  hl(0, "Error", { fg = c.error })
  hl(0, "Todo", { fg = c.bg, bg = c.warning, bold = true })

  -----------------------------------------------------------------------------
  -- Diff
  -----------------------------------------------------------------------------
  hl(0, "DiffAdd", { bg = c.diff_add })
  hl(0, "DiffChange", { bg = c.diff_change })
  hl(0, "DiffDelete", { bg = c.diff_delete })
  hl(0, "DiffText", { bg = c.diff_text })

  -----------------------------------------------------------------------------
  -- Spelling
  -----------------------------------------------------------------------------
  hl(0, "SpellBad", { undercurl = true, sp = c.error })
  hl(0, "SpellCap", { undercurl = true, sp = c.warning })
  hl(0, "SpellLocal", { undercurl = true, sp = c.info })
  hl(0, "SpellRare", { undercurl = true, sp = c.hint })

  -----------------------------------------------------------------------------
  -- Diagnostics
  -----------------------------------------------------------------------------
  hl(0, "DiagnosticError", { fg = c.error })
  hl(0, "DiagnosticWarn", { fg = c.warning })
  hl(0, "DiagnosticInfo", { fg = c.info })
  hl(0, "DiagnosticHint", { fg = c.hint })
  hl(0, "DiagnosticVirtualTextError", { fg = c.error, bg = c.bg_dark })
  hl(0, "DiagnosticVirtualTextWarn", { fg = c.warning, bg = c.bg_dark })
  hl(0, "DiagnosticVirtualTextInfo", { fg = c.info, bg = c.bg_dark })
  hl(0, "DiagnosticVirtualTextHint", { fg = c.hint, bg = c.bg_dark })
  hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = c.error })
  hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = c.warning })
  hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = c.info })
  hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = c.hint })
  hl(0, "DiagnosticFloatingError", { fg = c.error })
  hl(0, "DiagnosticFloatingWarn", { fg = c.warning })
  hl(0, "DiagnosticFloatingInfo", { fg = c.info })
  hl(0, "DiagnosticFloatingHint", { fg = c.hint })
  hl(0, "DiagnosticSignError", { fg = c.error })
  hl(0, "DiagnosticSignWarn", { fg = c.warning })
  hl(0, "DiagnosticSignInfo", { fg = c.info })
  hl(0, "DiagnosticSignHint", { fg = c.hint })

  -----------------------------------------------------------------------------
  -- LSP Semantic Tokens
  -----------------------------------------------------------------------------
  hl(0, "@lsp.type.class", { fg = c.amber })
  hl(0, "@lsp.type.decorator", { fg = c.purple })
  hl(0, "@lsp.type.enum", { fg = c.amber })
  hl(0, "@lsp.type.enumMember", { fg = c.sienna })
  hl(0, "@lsp.type.function", { fg = c.gold })
  hl(0, "@lsp.type.interface", { fg = c.amber })
  hl(0, "@lsp.type.macro", { fg = c.purple })
  hl(0, "@lsp.type.method", { fg = c.gold })
  hl(0, "@lsp.type.namespace", { fg = c.amber })
  hl(0, "@lsp.type.parameter", { fg = c.clay })
  hl(0, "@lsp.type.property", { fg = c.fg_dark })
  hl(0, "@lsp.type.struct", { fg = c.amber })
  hl(0, "@lsp.type.type", { fg = c.amber })
  hl(0, "@lsp.type.typeParameter", { fg = c.amber })
  hl(0, "@lsp.type.variable", { fg = c.fg })

  -----------------------------------------------------------------------------
  -- Treesitter Highlights
  -----------------------------------------------------------------------------
  -- Identifiers
  hl(0, "@variable", { fg = c.fg })
  hl(0, "@variable.builtin", { fg = c.clay, italic = true })
  hl(0, "@variable.parameter", { fg = c.clay })
  hl(0, "@variable.member", { fg = c.fg_dark })
  hl(0, "@constant", { fg = c.sienna })
  hl(0, "@constant.builtin", { fg = c.sienna, bold = true })
  hl(0, "@constant.macro", { fg = c.sienna })
  hl(0, "@module", { fg = c.amber })
  hl(0, "@label", { fg = c.rust })

  -- Literals
  hl(0, "@string", { fg = c.sage })
  hl(0, "@string.documentation", { fg = c.fg_gutter })
  hl(0, "@string.regexp", { fg = c.copper })
  hl(0, "@string.escape", { fg = c.moss })
  hl(0, "@string.special", { fg = c.moss })
  hl(0, "@character", { fg = c.sage })
  hl(0, "@character.special", { fg = c.moss })
  hl(0, "@boolean", { fg = c.sienna })
  hl(0, "@number", { fg = c.sienna })
  hl(0, "@number.float", { fg = c.sienna })

  -- Types
  hl(0, "@type", { fg = c.amber })
  hl(0, "@type.builtin", { fg = c.amber, italic = true })
  hl(0, "@type.definition", { fg = c.amber })
  hl(0, "@attribute", { fg = c.purple })
  hl(0, "@property", { fg = c.fg_dark })

  -- Functions
  hl(0, "@function", { fg = c.gold })
  hl(0, "@function.builtin", { fg = c.gold, italic = true })
  hl(0, "@function.call", { fg = c.gold })
  hl(0, "@function.macro", { fg = c.purple })
  hl(0, "@function.method", { fg = c.gold })
  hl(0, "@function.method.call", { fg = c.gold })
  hl(0, "@constructor", { fg = c.amber })

  -- Keywords
  hl(0, "@keyword", { fg = c.rust })
  hl(0, "@keyword.coroutine", { fg = c.rust })
  hl(0, "@keyword.function", { fg = c.rust })
  hl(0, "@keyword.operator", { fg = c.rust })
  hl(0, "@keyword.import", { fg = c.purple })
  hl(0, "@keyword.storage", { fg = c.rust })
  hl(0, "@keyword.repeat", { fg = c.rust })
  hl(0, "@keyword.return", { fg = c.rust })
  hl(0, "@keyword.debug", { fg = c.warning })
  hl(0, "@keyword.exception", { fg = c.rust })
  hl(0, "@keyword.conditional", { fg = c.rust })
  hl(0, "@keyword.directive", { fg = c.purple })

  -- Punctuation
  hl(0, "@punctuation.delimiter", { fg = c.stone })
  hl(0, "@punctuation.bracket", { fg = c.stone })
  hl(0, "@punctuation.special", { fg = c.copper })

  -- Comments
  hl(0, "@comment", { fg = c.fg_gutter, italic = true })
  hl(0, "@comment.documentation", { fg = c.fg_gutter })
  hl(0, "@comment.error", { fg = c.error })
  hl(0, "@comment.warning", { fg = c.warning })
  hl(0, "@comment.todo", { fg = c.bg, bg = c.warning, bold = true })
  hl(0, "@comment.note", { fg = c.info })

  -- Markup
  hl(0, "@markup.strong", { bold = true })
  hl(0, "@markup.italic", { italic = true })
  hl(0, "@markup.strikethrough", { strikethrough = true })
  hl(0, "@markup.underline", { underline = true })
  hl(0, "@markup.heading", { fg = c.gold, bold = true })
  hl(0, "@markup.quote", { fg = c.fg_dark, italic = true })
  hl(0, "@markup.math", { fg = c.sienna })
  hl(0, "@markup.link", { fg = c.blue, underline = true })
  hl(0, "@markup.link.label", { fg = c.blue })
  hl(0, "@markup.link.url", { fg = c.blue, underline = true })
  hl(0, "@markup.raw", { fg = c.sage })
  hl(0, "@markup.list", { fg = c.copper })

  -- Tags (HTML, JSX)
  hl(0, "@tag", { fg = c.umber })
  hl(0, "@tag.attribute", { fg = c.clay })
  hl(0, "@tag.delimiter", { fg = c.stone })

  -- Misc
  hl(0, "@operator", { fg = c.copper })
  hl(0, "@diff.plus", { fg = c.git_add })
  hl(0, "@diff.minus", { fg = c.git_delete })
  hl(0, "@diff.delta", { fg = c.git_change })

  -----------------------------------------------------------------------------
  -- Git Signs
  -----------------------------------------------------------------------------
  hl(0, "GitSignsAdd", { fg = c.git_add })
  hl(0, "GitSignsChange", { fg = c.git_change })
  hl(0, "GitSignsDelete", { fg = c.git_delete })
  hl(0, "GitSignsAddNr", { fg = c.git_add })
  hl(0, "GitSignsChangeNr", { fg = c.git_change })
  hl(0, "GitSignsDeleteNr", { fg = c.git_delete })
  hl(0, "GitSignsAddLn", { bg = c.diff_add })
  hl(0, "GitSignsChangeLn", { bg = c.diff_change })
  hl(0, "GitSignsDeleteLn", { bg = c.diff_delete })

  -----------------------------------------------------------------------------
  -- Telescope (if installed)
  -----------------------------------------------------------------------------
  hl(0, "TelescopeNormal", { fg = c.fg, bg = c.bg_dark })
  hl(0, "TelescopeBorder", { fg = c.border, bg = c.bg_dark })
  hl(0, "TelescopePromptNormal", { fg = c.fg, bg = c.bg_highlight })
  hl(0, "TelescopePromptBorder", { fg = c.border, bg = c.bg_highlight })
  hl(0, "TelescopePromptTitle", { fg = c.bg, bg = c.gold })
  hl(0, "TelescopePreviewTitle", { fg = c.bg, bg = c.sage })
  hl(0, "TelescopeResultsTitle", { fg = c.bg, bg = c.amber })
  hl(0, "TelescopeSelection", { fg = c.fg, bg = c.bg_highlight })
  hl(0, "TelescopeSelectionCaret", { fg = c.gold })
  hl(0, "TelescopeMatching", { fg = c.gold, bold = true })

  -----------------------------------------------------------------------------
  -- nvim-cmp (if installed)
  -----------------------------------------------------------------------------
  hl(0, "CmpItemAbbr", { fg = c.fg })
  hl(0, "CmpItemAbbrDeprecated", { fg = c.fg_gutter, strikethrough = true })
  hl(0, "CmpItemAbbrMatch", { fg = c.gold, bold = true })
  hl(0, "CmpItemAbbrMatchFuzzy", { fg = c.gold })
  hl(0, "CmpItemKind", { fg = c.amber })
  hl(0, "CmpItemMenu", { fg = c.fg_gutter })

  -----------------------------------------------------------------------------
  -- nvim-tree / neo-tree (if installed)
  -----------------------------------------------------------------------------
  hl(0, "NvimTreeNormal", { fg = c.fg, bg = c.bg_dark })
  hl(0, "NvimTreeFolderIcon", { fg = c.gold })
  hl(0, "NvimTreeFolderName", { fg = c.fg })
  hl(0, "NvimTreeOpenedFolderName", { fg = c.gold })
  hl(0, "NvimTreeRootFolder", { fg = c.amber, bold = true })
  hl(0, "NvimTreeGitDirty", { fg = c.git_change })
  hl(0, "NvimTreeGitNew", { fg = c.git_add })
  hl(0, "NvimTreeGitDeleted", { fg = c.git_delete })

  hl(0, "NeoTreeNormal", { fg = c.fg, bg = c.bg_dark })
  hl(0, "NeoTreeNormalNC", { fg = c.fg, bg = c.bg_dark })
  hl(0, "NeoTreeDirectoryIcon", { fg = c.gold })
  hl(0, "NeoTreeDirectoryName", { fg = c.fg })
  hl(0, "NeoTreeRootName", { fg = c.amber, bold = true })
  hl(0, "NeoTreeGitModified", { fg = c.git_change })
  hl(0, "NeoTreeGitAdded", { fg = c.git_add })
  hl(0, "NeoTreeGitDeleted", { fg = c.git_delete })

  -----------------------------------------------------------------------------
  -- Indent Blankline (if installed)
  -----------------------------------------------------------------------------
  hl(0, "IndentBlanklineChar", { fg = c.bg_highlight })
  hl(0, "IndentBlanklineContextChar", { fg = c.border })
  hl(0, "IblIndent", { fg = c.bg_highlight })
  hl(0, "IblScope", { fg = c.border })

  -----------------------------------------------------------------------------
  -- Which-key (if installed)
  -----------------------------------------------------------------------------
  hl(0, "WhichKey", { fg = c.gold })
  hl(0, "WhichKeyGroup", { fg = c.amber })
  hl(0, "WhichKeyDesc", { fg = c.fg })
  hl(0, "WhichKeySeperator", { fg = c.fg_gutter })
  hl(0, "WhichKeySeparator", { fg = c.fg_gutter })
  hl(0, "WhichKeyFloat", { bg = c.bg_dark })
  hl(0, "WhichKeyValue", { fg = c.fg_gutter })

  -----------------------------------------------------------------------------
  -- Lazy.nvim
  -----------------------------------------------------------------------------
  hl(0, "LazyNormal", { fg = c.fg, bg = c.bg_dark })
  hl(0, "LazyButton", { fg = c.fg, bg = c.bg_highlight })
  hl(0, "LazyButtonActive", { fg = c.bg, bg = c.gold })
  hl(0, "LazyH1", { fg = c.bg, bg = c.gold, bold = true })
  hl(0, "LazyH2", { fg = c.gold, bold = true })
  hl(0, "LazySpecial", { fg = c.amber })
  hl(0, "LazyProgressDone", { fg = c.gold })
  hl(0, "LazyProgressTodo", { fg = c.fg_gutter })
end

return M
