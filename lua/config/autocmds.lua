local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- loading Lua modules
vim.loader.enable()

-- Neovide configuration
if vim.g.neovide then
  vim.o.guifont = "Operator Mono Lig:h6"
  -- vim.o.guifont = "CaskaydiaCove Nerd Font Mono:h5.1"
  -- vim.o.guifont = "VictorMono Nerd Font:h5.1:b"
  vim.opt.linespace = 2
  vim.g.neovide_scale_factor = 2
  vim.g.neovide_transparency = 1
  vim.g.neovide_background_color = "#0B0E14"
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_remember_window_size = true
end

-- Change font size in Neovide
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.25)
end, { desc = "Increase font size" })

vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1 / 1.25)
end, { desc = "Decrease font size" })

-- Turn off paste mode when leaving insert mode
autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Resize splits if window got resized
autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "fugitive",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto create dir when saving a file
autocmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Terminal settings
autocmd("TermOpen", {
  group = augroup("terminal_settings", { clear = true }),
  callback = function()
    local opts = { buffer = 0, noremap = true, silent = true }
    -- Exit terminal mode with Esc
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
    -- Re-enter terminal mode with Esc in normal mode for terminal buffers
    vim.keymap.set("n", "<Esc>", function()
      if vim.bo.buftype == "terminal" then
        vim.cmd("startinsert")
      end
    end, opts)
    -- Remove line numbers and signcolumn in terminal
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Check if file needs to be reloaded when changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Go formatting on save
autocmd("BufWritePre", {
  pattern = "*.go",
  group = augroup("go_format", { clear = true }),
  callback = function()
    local ok, go_format = pcall(require, 'go.format')
    if ok then
      go_format.goimport()
    end
  end,
})

-- Fix conceallevel for json files
autocmd("FileType", {
  group = augroup("json_conceal", { clear = true }),
  pattern = { "json", "jsonc" },
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.wo.spell = false
  end,
})

-- Fix conceallevel for markdown files
autocmd("FileType", {
  group = augroup("markdown_conceal", { clear = true }),
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})