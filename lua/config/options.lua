-- Set options for better performance and UX
local opt = vim.opt
local g = vim.g

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.redrawtime = 10000
opt.synmaxcol = 240
opt.lazyredraw = false -- do not redraw while executing macros (improve performance)

-- UI
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 1
opt.signcolumn = "number"
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.colorcolumn = "120"
opt.showmatch = true -- highlight matching parentheses
opt.showcmd = true -- show the commands
opt.title = true -- show the file name
opt.laststatus = 3 -- set when show the statusline [3: always and only the last window]
opt.showtabline = 0
opt.mousemoveevent = true
opt.emoji = true
opt.pumblend = 10                    -- Transparency for popup menu
opt.winblend = 10                    -- Transparency for floating windows

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true -- keep the tab of the previous line
opt.breakindent = true
opt.linebreak = true -- wrap on word boundary

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true -- ignore case letters when search a word
opt.smartcase = false -- ignore lower case for the whole pattern

-- Files & backup
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.autoread = true
opt.autowrite = true
opt.hidden = true -- allows switch between buffers and not closing them
opt.encoding = "utf-8" -- enables international characters

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 15
opt.pumblend = 10
opt.winblend = 10

-- Splits
opt.splitbelow = true -- set the splits to open at the below
opt.splitright = true -- set the splits to open at the right side

-- Clipboard
opt.clipboard = "unnamedplus" -- allows to use the OS clipboard

-- Concealer
opt.conceallevel = 2

-- Mouse
opt.mouse = "a" -- allows use the mouse

-- Shell and language
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  opt.shell = "pwsh" -- ou "cmd" se preferir
else
  opt.shell = "/bin/zsh" -- Para Linux/macOS
end
opt.spelllang = "en,pt" -- correct the words using Portuguese and English dictionary

-- Color schemes config
opt.syntax = "enable" -- show the syntax
opt.background = "dark"

-- Listchars for better visual feedback
opt.list = true
local space = "·"
opt.listchars:append({
  tab = "│ ",
  trail = space,
  nbsp = space,
})

-- Performance optimizations - disable unused providers and plugins
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Disable unused built-in plugins for better performance
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1

g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1

g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1

-- Netrw
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1

-- Go settings
g.go_fmt_command = "gofumpt"
g.go_imports_autosave = 1
g.go_fmt_autosave = 1
g.go_mod_fmt_autosave = 1