local keymap = vim.keymap.set

--  up/down for wrapped lines
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

--  escape
keymap("i", "jj", "<Esc>", { desc = "Escape to normal mode" })

-- Clear search highlights
keymap("n", "<leader><space>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })
keymap("n", "ss", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

--  indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Quick save and quit
keymap("n", "WW", "<cmd>w!<cr>", { desc = "Force save" })
keymap("n", "QQ", "<cmd>q!<cr>", { desc = "Force quit" })

-- Buffer navigation
keymap("n", "tl", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "th", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "td", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
keymap("n", "tj", "<cmd>bfirst<cr>", { desc = "First buffer" })
keymap("n", "tk", "<cmd>blast<cr>", { desc = "Last buffer" })

-- Window management
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
keymap("n", "<C-w>,", "<cmd>vertical resize -10<cr>", { desc = "Decrease window width" })
keymap("n", "<C-w>.", "<cmd>vertical resize +10<cr>", { desc = "Increase window width" })
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })

-- Line navigation
keymap("n", "B", "^", { desc = "Go to beginning of line" })
keymap("n", "E", "$", { desc = "Go to end of line" })

-- Diagnostic navigation
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic list" })

-- Split windows
keymap("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
keymap("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal split" })

-- Quick quit window
keymap("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit window" })

-- Disable space in normal and visual modes
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Delete without yanking
keymap({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })