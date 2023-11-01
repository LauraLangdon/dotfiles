local M = {}

M.base_30 = {
  white = "#963896",
  darker_black = "#f7eef4", -- left sidebar
  black = "#fffcff", --  nvim bg
  black2 = "#fff3f9",
  one_bg = "#eedde9",
  one_bg2 = "#fff3f9", -- StatusBar (filename)
  one_bg3 = "#ddbbd2",
  grey = "#b3b3cc", -- Line numbers )
  grey_fg = "#a3a3c2",
  grey_fg2 = "#ddbbd2",
  light_grey = "#00a5b3",
  red = "#e91686", -- StatusBar (username)
  baby_pink = "#ffb3c6",
  pink = "#f96cb7",
  line = "#999cff", -- for lines like vertsplit
  green = "#963896",
  vibrant_green = "#00aa64",
  nord_blue = "#999cff", -- Mode indicator
  blue = "#666bff",
  yellow = "#f9c006",
  sun = "#f9c513",
  purple = "#cc00ff",
  dark_purple = "#5a32a3",
  teal = "#22839b",
  orange = "#ff9900",
  cyan = "#00a5b3",
  statusline_bg = "#ddbbd2",
  pmenu_bg = "#999cff",
  folder_bg = "#cd1885",
}

M.base_16 = {
  base00 = M.base_30.black, -- Default bg
  base01 = "#ccceff", -- Lighter bg (status bar, line number, folding mks)
  base02 = "#e6e6ff", -- Selection bg
  base03 = M.base_30.blue, -- Comments, invisibles, line hl
  base04 = M.base_30.dark_purple, -- Dark fg (status bars)
  base05 = "#5d225d", -- Default fg (caret, delimiters, Operators)
  base06 = "#5c5c8a", -- Light fg (not often used)
  base07 = "#eedde9", -- Light bg (not often used)
  base08 = M.base_30.vibrant_green, -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = "#ff9900", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = M.base_30.pink, -- Classes, Markup Bold, Search Text Backgroun
  base0B = M.base_30.blue, -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = "#8263EB", -- Support, regex, escape chars
  base0D = M.base_30.cyan, -- Function, methods, headings
  base0E = M.base_30.purple, -- Keywords
  base0F = "#044289", -- Deprecated, open/close embedded tags
}

M.type = "light"

M.polish_hl = {
  ["@punctuation.bracket"] = {
    fg = M.base_30.blue,
  },

  ["@field.key"] = {
    fg = M.base_30.darker_black,
  },

  Constant = {
    fg = M.base_16.base07,
  },

  ["@constructor"] = {
    fg = M.base_30.vibrant_green,
  },

  Tag = {
    fg = M.base_30.vibrant_green,
  },

  ["@operator"] = {
    fg = M.base_30.red,
  }
}

M = require("base46").override_theme(M, "light-pinkish")

return M
