-- Set leader keys before loading anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Setup lazy.nvim and load all plugins
require("config.lazy")