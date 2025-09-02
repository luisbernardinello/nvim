return {
  -- File Explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer NeoTree" },
      { "<leader>E", "<cmd>Neotree focus<cr>", desc = "Focus NeoTree" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
          indent = {
            with_expanders = true,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
          },
          git_status = {
            symbols = {
              added = "",
              deleted = "",
              modified = "",
              renamed = "➜",
              untracked = "★",
              ignored = "◌",
              unstaged = "✗",
              staged = "✓",
              conflict = "",
            },
          },
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          hijack_netrw = true,
          use_libuv_file_watcher = true,
          window = {
            position = "right",
            width = 35,
            mappings = {
              ["<space>"] = "none",
              ["h"] = "close_node",
              ["l"] = "open", 
              ["o"] = "open",
              ["<cr>"] = "open",
              ["<2-LeftMouse>"] = "open",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
              ["a"] = { 
                "add",
                config = {
                  show_path = "none" -- "none", "relative", "absolute"
                }
              },
              ["A"] = "add_directory",
              ["d"] = "delete",
              ["r"] = "rename",
              ["y"] = "copy_to_clipboard",
              ["x"] = "cut_to_clipboard",
              ["p"] = "paste_from_clipboard",
              ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add"
              ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add"
              ["q"] = "close_window",
              ["R"] = "refresh",
              ["?"] = "show_help",
              ["<"] = "prev_source",
              [">"] = "next_source",
            },
          },
        },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    keys = {
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Grep String" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>sS", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<leader>?", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader><tab>", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>/", function()
          require("telescope.builtin").current_buffer_fuzzy_find(
            require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
          )
        end, desc = "Search in Buffer" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-symbols.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = { "node_modules" },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Load extensions
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "git_worktree")
    end,
  },

  -- Which-key
 -- Which-key
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function()
    local wk = require("which-key")
    
    wk.setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = false,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      win = {
        border = "rounded",
        no_overlap = true,
        padding = { 2, 2 }, -- Mais padding para ficar mais bonito
        title = true,
        title_pos = "center",
        zindex = 1000,
        -- Configurações para layout vertical e mais bonito
        width = { min = 25, max = 50 }, -- Largura ajustável
        height = { min = 10, max = 25 }, -- Altura ajustável
        col = 0.5, -- Centralizado horizontalmente
        row = 0.4, -- Posicionado um pouco acima do centro
      },
      layout = {
        width = { min = 20, max = 50 },
        height = { min = 1, max = 25 },
        spacing = 4, -- Espaçamento entre itens
        align = "left", -- Alinhamento do texto
      },
      show_help = true,
      show_keys = true,
      -- Ícones mais bonitos
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
        mappings = true,
        rules = {
          -- Ícones customizados por função
          { pattern = "find", icon = " ", color = "azure" },
          { pattern = "search", icon = " ", color = "green" },
          { pattern = "file", icon = " ", color = "blue" },
          { pattern = "buffer", icon = " ", color = "cyan" },
          { pattern = "git", icon = " ", color = "orange" },
          { pattern = "lsp", icon = " ", color = "yellow" },
          { pattern = "debug", icon = " ", color = "red" },
          { pattern = "test", icon = "󰙨 ", color = "purple" },
          { pattern = "toggle", icon = " ", color = "yellow" },
          { pattern = "window", icon = " ", color = "blue" },
          { pattern = "split", icon = " ", color = "cyan" },
        },
      },
      -- Melhor filtragem
      filter = function(mapping)
        return mapping.desc and mapping.desc ~= ""
      end,
      -- Melhor formatação
      sort = { "local", "order", "group", "alphanum", "mod" },
    })

    -- Definições completas (mantendo tudo que você tinha + melhorias)
    wk.add({
      -- ================== GRUPOS PRINCIPAIS ==================
      { "<leader>b", group = " Buffers" },
      { "<leader>c", group = " Code" },
      { "<leader>d", group = " Debug" },
      { "<leader>f", group = " Find" }, -- Adicionando grupo Find
      { "<leader>g", group = " Git/Go" },
      { "<leader>h", group = "󰛢 Harpoon" },
      { "<leader>l", group = " LSP" },
      { "<leader>n", group = " Neogen" },
      { "<leader>p", group = " Python" },
      { "<leader>r", group = " REPL" },
      { "<leader>s", group = " Search" },
      { "<leader>t", group = "󰙨 Test/Toggle" },
      { "<leader>u", group = " Utils" },
      { "<leader>v", group = " Venv" },
      { "<leader>w", group = " Windows" },
      { "<leader>x", group = " Diagnostics/Quickfix" },

      -- ================== KEYMAPS PRINCIPAIS ==================
      -- Principais
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = " Explorer NeoTree" },
      { "<leader>E", "<cmd>Neotree focus<cr>", desc = " Focus NeoTree" },
      { "<leader><space>", "<cmd>nohlsearch<cr>", desc = " Clear search highlights" },
      { "<leader>qq", "<cmd>q<cr>", desc = "󰅖 Quit window" },
      { "<leader>|", "<cmd>vsplit<cr>", desc = " Vertical split" },
      { "<leader>-", "<cmd>split<cr>", desc = " Horizontal split" },

      -- Telescope/Search (mantendo todos os seus)
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = " Find Files" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = " Live Grep" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = " Find Buffers" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = " Help Tags" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = " Grep String" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = " Diagnostics" },
      { "<leader>sS", "<cmd>Telescope git_status<cr>", desc = " Git Status" },
      { "<leader>?", "<cmd>Telescope oldfiles<cr>", desc = "󰋚 Recent Files" },
      { "<leader><tab>", "<cmd>Telescope commands<cr>", desc = " Commands" },
      { "<leader>/", function()
          require("telescope.builtin").current_buffer_fuzzy_find(
            require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
          )
        end, desc = " Search in Buffer" },

      -- Git Worktree
      { "<leader>sr", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>", desc = " Git worktrees" },
      { "<leader>sR", "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>", desc = " Create worktree" },

      -- Session management
      { "<leader>so", "<cmd>Obsess<cr>", desc = " Start session" },
      { "<leader>sO", "<cmd>Obsess!<cr>", desc = "󰅙 Stop session" },

      -- ================== BUFFERS ==================
      { "<leader>bn", "<cmd>bnext<cr>", desc = "󰒭 Next Buffer" },
      { "<leader>bp", "<cmd>bprevious<cr>", desc = "󰒮 Previous Buffer" },
      { "<leader>bd", "<cmd>bdelete<cr>", desc = " Delete Buffer" },
      { "<leader>bl", "<cmd>Telescope buffers<cr>", desc = " List Buffers" },

      -- ================== WINDOW MANAGEMENT ==================
      { "<leader>ws", function()
          vim.cmd("split")
          vim.cmd("enew")
        end, desc = " Horizontal Split (Empty)" },
      { "<leader>wv", function()
          vim.cmd("vsplit") 
          vim.cmd("enew")
        end, desc = " Vertical Split (Empty)" },
      { "<leader>wc", function()
          local current_buf = vim.api.nvim_get_current_buf()
          vim.cmd("close")
          vim.cmd("bdelete " .. current_buf)
        end, desc = "󰅖 Close Window and Buffer" },
      { "<leader>wo", "<cmd>only<cr>", desc = " Close Other Windows" },
      { "<leader>wq", "<cmd>q<cr>", desc = "󰅖 Quit Window" },

      -- Window switching numerado (mantendo o seu)
      { "<leader>1", function() require("utils").switch_to_window(1) end, desc = "󰎤 Window 1" },
      { "<leader>2", function() require("utils").switch_to_window(2) end, desc = "󰎧 Window 2" },
      { "<leader>3", function() require("utils").switch_to_window(3) end, desc = "󰎪 Window 3" },
      { "<leader>4", function() require("utils").switch_to_window(4) end, desc = "󰎭 Window 4" },

      -- ================== LSP ACTIONS ==================
      { "<leader>li", "<cmd>LspInfo<cr>", desc = " LSP Info" },
      { "<leader>lr", "<cmd>LspRestart<cr>", desc = " LSP Restart" },
      { "<leader>lf", "<cmd>Format<cr>", desc = " Format code" },

      -- Code actions (mantendo os seus)
      { "<leader>ca", vim.lsp.buf.code_action, desc = " Code Action" },
      { "<leader>cr", vim.lsp.buf.rename, desc = " Rename" },
      { "<leader>cf", function() require("utils").format({ force = true }) end, desc = " Format Code" },
      { "<leader>cF", function() require("utils").toggle_autoformat() end, desc = " Toggle Autoformat" },

      -- ================== TOGGLES ==================
      { "<leader>tz", "<cmd>ZenMode<cr>", desc = "󰚀 Toggle Zen Mode" },
      { "<leader>nn", "<cmd>Noice dismiss<cr>", desc = " Dismiss Noice" },
      { "<leader>tt", "<cmd>Twilight<cr>", desc = "🌅 Toggle Twilight" },
      { "<leader>tg", "<cmd>Gitsigns toggle_signs<cr>", desc = " Toggle Git Signs" },

      -- Terminal (mantendo os seus)
      { "<leader>tb", function() require("utils").open_terminal("horizontal", "below") end, desc = " Terminal Below" },
      { "<leader>ta", function() require("utils").open_terminal("horizontal", "above") end, desc = " Terminal Above" },

      -- ================== DIAGNOSTIC NAVIGATION ==================
      { "<leader>dn", vim.diagnostic.goto_next, desc = " Next Diagnostic" },
      { "<leader>dp", vim.diagnostic.goto_prev, desc = " Previous Diagnostic" },
      { "<leader>dl", "<cmd>Telescope diagnostics<cr>", desc = " List Diagnostics" },

      -- ================== HARPOON ==================
      { "<leader>m", function() require("harpoon"):list():add() end, desc = "󰛢 Harpoon file" },
      { "<leader>ht", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "󰛢 Harpoon quick menu" },
      { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "󰎤 Harpoon to file 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "󰎧 Harpoon to file 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "󰎪 Harpoon to file 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "󰎭 Harpoon to file 4" },

      -- ================== UTILITIES ==================
      { "<leader>ur", function() require("utils").reload("config") end, desc = " Reload Config" },
      { "<leader>uh", function() require("utils").get_highlight_under_cursor() end, desc = " Highlight Under Cursor" },
      { "<leader>ut", function() require("utils").toggle_theme() end, desc = " Toggle Theme" },

      -- ================== GOTO PREVIEW ==================
      -- Estes não aparecem no which-key pois não usam <leader>, mas adicionando para referência
      mode = { "n" }, -- Garantir que são para modo normal
    })
  end,
},

  -- Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
      { "<leader>m", function() require("harpoon"):list():add() end, desc = "Harpoon file" },
      { "<leader>ht", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon quick menu" },
      -- Mudando os keymaps do Harpoon para não conflitar com window switching
      { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "Harpoon to file 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "Harpoon to file 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "Harpoon to file 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "Harpoon to file 4" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<c-\\>", desc = "Terminal" },
      { "<leader>tb", function() require("utils").open_terminal("horizontal", "below") end, desc = "Terminal Below" },
      { "<leader>ta", function() require("utils").open_terminal("horizontal", "above") end, desc = "Terminal Above" },
    },
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        persist_size = true,
        direction = "float",
        float_opts = {
          border = "curved",
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.8),
        },
      })
    end,
  },

  -- Auto detect tabstop and shiftwidth
  {
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Session management
  {
    "tpope/vim-obsession",
    keys = {
      { "<leader>so", "<cmd>Obsess<cr>", desc = "Start session" },
      { "<leader>sO", "<cmd>Obsess!<cr>", desc = "Stop session" },
    },
  },

  -- Goto Preview
  {
    "rmagatti/goto-preview",
    keys = {
      { "gpd", function() require("goto-preview").goto_preview_definition() end, desc = "Preview Definition" },
      { "gpi", function() require("goto-preview").goto_preview_implementation() end, desc = "Preview Implementation" },
      { "gpr", function() require("goto-preview").goto_preview_references() end, desc = "Preview References" },
      { "gpt", function() require("goto-preview").goto_preview_type_definition() end, desc = "Preview Type Definition" },
      { "gP", function() require("goto-preview").close_all_win() end, desc = "Close all preview windows" },
    },
    config = function()
      require("goto-preview").setup({
        width = 120,
        height = 15,
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
        default_mappings = false,
        debug = false,
        opacity = nil,
        resizing_mappings = false,
        post_open_hook = nil,
        focus_on_open = true,
        dismiss_on_move = false,
        force_close = true,
        bufhidden = "wipe",
        stack_floating_preview_windows = true,
        preview_window_title = { enable = true, position = "left" },
      })
    end,
  },

  -- Git Worktree
  {
    "ThePrimeagen/git-worktree.nvim",
    keys = {
      { "<leader>sr", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>", desc = "Git worktrees" },
      { "<leader>sR", "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>", desc = "Create worktree" },
    },
    config = function()
      require("git-worktree").setup()
      require("telescope").load_extension("git_worktree")
    end,
  },
}