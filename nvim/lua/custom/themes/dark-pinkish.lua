local M = {}

M.base_30 = {
  white = "#dfafe9",
  darker_black = "#17062d", -- left sidebar
  black = "#120128", --  nvim bg
  black2 = "#50159d",
  one_bg = "#eedde9",
  one_bg2 = "#50159d", -- StatusBar (filename)
  one_bg3 = "#ddbbd2",
  grey = "#df9bff", -- Line numbers )
  grey_fg = "#987a9f",
  grey_fg2 = "#ddbbd2",
  light_grey = "#01c7e0",
  red = "#f021b7", -- StatusBar (username)
  baby_pink = "#f5a3ea",
  pink = "#ef67cd",
  line = "#01c7e0", -- for lines like vertsplit
  green = "#ea5ea8",
  vibrant_green = "#00cc99",
  nord_blue = "#999cff", -- Mode indicator
  blue = "#99a8ff",
  yellow = "#ffc466",
  sun = "#f9c513",
  purple = "#c96ef7",
  dark_purple = "#ea5ea8",
  teal = "#22839b",
  orange = "#ff9900",
  cyan = "#01c7e0",
  statusline_bg = "#36003d",
  pmenu_bg = "#999cff",
  folder_bg = "#ea5ea8",
}

M.base_16 = {
  base00 = M.base_30.black, -- Default bg
  base01 = "#ccceff", -- Lighter bg (status bar, line number, folding mks)
  base02 = "#dbd7ff", -- Selection bg
  base03 = M.base_30.blue, -- Comments, invisibles, line hl
  base04 = M.base_30.dark_purple, -- Dark fg (status bars)
  base05 = "#e6b6f0", -- Default fg (caret, delimiters, Operators)
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

M.type = "dark"

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
    fg = M.base_30.pink,
  }
}

M = require("base46").override_theme(M, "dark-pinkish")

return M
