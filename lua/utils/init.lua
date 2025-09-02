local M = {}

-- Format function with force option
function M.format(opts)
  opts = opts or {}
  local force = opts.force or false
  
  -- Check if LSP supports formatting
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  local has_formatter = false
  
  for _, client in ipairs(clients) do
    if client.supports_method("textDocument/formatting") then
      has_formatter = true
      break
    end
  end
  
  if has_formatter then
    vim.lsp.buf.format({
      async = false,
      filter = function(client)
        -- You can customize which clients to use for formatting
        return client.supports_method("textDocument/formatting")
      end,
    })
    vim.notify("Buffer formatted", vim.log.levels.INFO)
  elseif force then
    -- Fallback to basic indentation fix
    local view = vim.fn.winsaveview()
    vim.cmd("normal! gg=G")
    vim.fn.winrestview(view)
    vim.notify("Buffer indentation fixed", vim.log.levels.INFO)
  else
    vim.notify("No formatter available", vim.log.levels.WARN)
  end
end

-- Toggle autoformat
local autoformat_enabled = true
function M.toggle_autoformat()
  autoformat_enabled = not autoformat_enabled
  if autoformat_enabled then
    vim.notify("Autoformat enabled", vim.log.levels.INFO)
  else
    vim.notify("Autoformat disabled", vim.log.levels.WARN)
  end
end

-- Check if autoformat is enabled
function M.is_autoformat_enabled()
  return autoformat_enabled
end

-- Switch to window by number (like Emacs)
function M.switch_to_window(num)
  local windows = vim.api.nvim_tabpage_list_wins(0)
  if num <= #windows then
    vim.api.nvim_set_current_win(windows[num])
  else
    vim.notify("Window " .. num .. " does not exist", vim.log.levels.WARN)
  end
end

-- Reload configuration module
function M.reload(module_name)
  module_name = module_name or "config"
  
  -- Clear the module from package.loaded
  for name, _ in pairs(package.loaded) do
    if name:match("^" .. module_name) then
      package.loaded[name] = nil
    end
  end
  
  -- Reload the configuration
  vim.cmd("source $MYVIMRC")
  vim.notify("Configuration reloaded", vim.log.levels.INFO)
end

-- Get highlight group under cursor
function M.get_highlight_under_cursor()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local highlight = vim.fn.synIDattr(vim.fn.synID(line, col + 1, true), "name")
  
  if highlight == "" then
    highlight = "No highlight group"
  end
  
  vim.notify("Highlight: " .. highlight, vim.log.levels.INFO)
  return highlight
end

-- Toggle between light and dark themes
local current_theme = "dark"
function M.toggle_theme()
  if current_theme == "dark" then
    vim.opt.background = "light"
    current_theme = "light"
    vim.notify("Switched to light theme", vim.log.levels.INFO)
  else
    vim.opt.background = "dark"
    current_theme = "dark"
    vim.notify("Switched to dark theme", vim.log.levels.INFO)
  end
end

-- Terminal utilities
function M.open_terminal(direction, position)
  direction = direction or "horizontal"
  position = position or "below"
  
  if direction == "horizontal" then
    -- Obtem o diretório do arquivo atual
    local current_dir = vim.fn.expand("%:p:h")
    -- Se não tiver arquivo aberto, usar o diretório de trabalho atual
    if current_dir == "" or current_dir == "." then
      current_dir = vim.fn.getcwd()
    end
    
    if position == "above" then
      vim.cmd("topleft 15split")
    else
      vim.cmd("botright 15split") 
    end
    
    -- Mudar para o diretório correto antes de abrir o terminal
    vim.cmd("lcd " .. vim.fn.fnameescape(current_dir))
    vim.cmd("terminal")
    vim.cmd("startinsert")
  end
end

-- Buffer utilities
function M.close_buffer_and_window()
  local current_buf = vim.api.nvim_get_current_buf()
  local windows = vim.api.nvim_list_wins()
  local current_win = vim.api.nvim_get_current_win()
  
  -- Check if there are other windows
  if #windows > 1 then
    vim.cmd("close")
  end
  
  -- Check if buffer is modified
  if vim.api.nvim_buf_get_option(current_buf, "modified") then
    local choice = vim.fn.confirm("Buffer has unsaved changes. Save before closing?", "&Yes\n&No\n&Cancel", 3)
    if choice == 1 then
      vim.cmd("write")
    elseif choice == 3 then
      return
    end
  end
  
  vim.cmd("bdelete " .. current_buf)
end

-- Smart split functions
function M.smart_split_horizontal()
  vim.cmd("split")
  vim.cmd("enew")
end

function M.smart_split_vertical()
  vim.cmd("vsplit")
  vim.cmd("enew")
end

-- Get project root (useful for various operations)
function M.get_project_root()
  local root_patterns = { ".git", ".gitignore", "package.json", "Cargo.toml", "go.mod", "pyproject.toml", "Makefile" }
  local current_dir = vim.fn.expand("%:p:h")
  
  local function find_root(path)
    for _, pattern in ipairs(root_patterns) do
      if vim.fn.glob(path .. "/" .. pattern) ~= "" then
        return path
      end
    end
    
    local parent = vim.fn.fnamemodify(path, ":h")
    if parent == path then
      return nil
    end
    
    return find_root(parent)
  end
  
  return find_root(current_dir) or vim.fn.getcwd()
end

-- Quick file operations
function M.create_file()
  local filename = vim.fn.input("New file name: ")
  if filename ~= "" then
    vim.cmd("edit " .. filename)
  end
end

function M.create_directory()
  local dirname = vim.fn.input("New directory name: ")
  if dirname ~= "" then
    vim.fn.mkdir(dirname, "p")
    vim.notify("Directory created: " .. dirname, vim.log.levels.INFO)
  end
end

-- LSP utilities
function M.restart_lsp()
  vim.cmd("LspRestart")
  vim.notify("LSP restarted", vim.log.levels.INFO)
end

function M.show_lsp_info()
  vim.cmd("LspInfo")
end

-- Diagnostic utilities
function M.toggle_diagnostics()
  local is_enabled = vim.diagnostic.is_disabled(0)
  if is_enabled then
    vim.diagnostic.enable()
    vim.notify("Diagnostics enabled", vim.log.levels.INFO)
  else
    vim.diagnostic.disable()
    vim.notify("Diagnostics disabled", vim.log.levels.WARN)
  end
end

-- Quick search utilities
function M.search_current_word()
  local word = vim.fn.expand("<cword>")
  require("telescope.builtin").grep_string({ search = word })
end

function M.search_visual_selection()
  local text = vim.fn.getline("'<", "'>")
  if #text > 0 then
    require("telescope.builtin").grep_string({ search = table.concat(text, "\n") })
  end
end

-- Session utilities
function M.save_session()
  local session_name = vim.fn.input("Session name: ", vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))
  if session_name ~= "" then
    vim.cmd("mksession! ~/.config/nvim/sessions/" .. session_name .. ".vim")
    vim.notify("Session saved: " .. session_name, vim.log.levels.INFO)
  end
end

function M.load_session()
  local sessions_dir = vim.fn.expand("~/.config/nvim/sessions/")
  local sessions = vim.fn.glob(sessions_dir .. "*.vim", false, true)
  
  if #sessions == 0 then
    vim.notify("No sessions found", vim.log.levels.WARN)
    return
  end
  
  local session_names = {}
  for _, session in ipairs(sessions) do
    local name = vim.fn.fnamemodify(session, ":t:r")
    table.insert(session_names, name)
  end
  
  vim.ui.select(session_names, {
    prompt = "Select session:",
  }, function(choice)
    if choice then
      vim.cmd("source " .. sessions_dir .. choice .. ".vim")
      vim.notify("Session loaded: " .. choice, vim.log.levels.INFO)
    end
  end)
end

-- Initialize sessions directory
local function init_sessions_dir()
  local sessions_dir = vim.fn.expand("~/.config/nvim/sessions/")
  if vim.fn.isdirectory(sessions_dir) == 0 then
    vim.fn.mkdir(sessions_dir, "p")
  end
end

-- Auto setup for format on save
function M.setup_format_on_save()
  local augroup = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    callback = function()
      if M.is_autoformat_enabled() then
        M.format()
      end
    end,
  })
end

-- Initialize utils
function M.setup()
  init_sessions_dir()
  -- You can add other initialization code here
end

return M