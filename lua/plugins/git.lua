return {
  -- Fugitive for Git commands
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
    ft = { "fugitive" },
    keys = {
      { "<leader>gB", "<cmd>G blame<cr>", desc = "Git Blame" },
    },
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            require("gitsigns").next_hunk()
          end)
          return "<Ignore>"
        end, expr = true, desc = "Next hunk" },
      { "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            require("gitsigns").prev_hunk()
          end)
          return "<Ignore>"
        end, expr = true, desc = "Previous hunk" },
      { "<leader>hs", ":Gitsigns stage_hunk<cr>", mode = { "n", "v" }, desc = "Stage hunk" },
      { "<leader>hr", ":Gitsigns reset_hunk<cr>", mode = { "n", "v" }, desc = "Reset hunk" },
      { "<leader>hS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage buffer" },
      { "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo stage hunk" },
      { "<leader>hR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset buffer" },
      { "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
      { "<leader>hb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame line" },
      { "<leader>hd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this" },
      { "<leader>hD", function() require("gitsigns").diffthis("~") end, desc = "Diff this ~" },
      { "<leader>tg", "<cmd>Gitsigns toggle_signs<cr>", desc = "Toggle git signs" },
      { "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle git blame line" },
      { "ih", ":<C-U>Gitsigns select_hunk<cr>", mode = { "o", "x" }, desc = "Select hunk" },
    },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        signs_staged = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        preview_config = {
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        yadm = {
          enable = false,
        },
      })
    end,
  },

  -- Neogit - Git porcelain
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
      { "<leader>gs", "<cmd>Neogit<cr>", desc = "Git Status" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git Commit" },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Git Pull" },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Git Push" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        disable_signs = false,
        disable_hint = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = false,
        disable_builtin_editor = false,
        disable_insert_on_commit = true,
        use_magit_keybindings = false,
        auto_refresh = true,
        auto_show_console = true,
        remember_settings = true,
        use_per_project_settings = true,
        console_timeout = 2000,
        auto_close_console = true,
        kind = "tab",
        status = {
          recent_commit_count = 10,
        },
        commit_editor = {
          kind = "split",
        },
        commit_select_view = {
          kind = "tab",
        },
        commit_view = {
          kind = "vsplit",
          verify_commit = os.execute("which gpg") == 0,
        },
        log_view = {
          kind = "tab",
        },
        rebase_editor = {
          kind = "split",
        },
        reflog_view = {
          kind = "tab",
        },
        merge_editor = {
          kind = "split",
        },
        tag_editor = {
          kind = "split",
        },
        preview_buffer = {
          kind = "split",
        },
        popup = {
          kind = "split",
        },
        signs = {
          hunk = { "", "" },
          item = { ">", "v" },
          section = { ">", "v" },
        },
        integrations = {
          telescope = true,
          diffview = true,
        },
        sections = {
          untracked = {
            folded = false,
          },
          unstaged = {
            folded = false,
          },
          staged = {
            folded = false,
          },
          stashes = {
            folded = true,
          },
          unpulled = {
            folded = true,
          },
          unmerged = {
            folded = false,
          },
          recent = {
            folded = true,
          },
        },
      })
    end,
  },

  -- Better diff view
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>df", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle Diffview Files" },
    },
    config = function()
      require("diffview").setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        git_cmd = { "git" },
        use_icons = true,
        watch_index = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        view = {
          default = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = {
            flatten_dirs = true,
            folder_statuses = "only_folded",
          },
          win_config = {
            position = "left",
            width = 35,
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = "combined",
              },
              multi_file = {
                diff_merges = "first-parent",
              },
            },
          },
          win_config = {
            position = "bottom",
            height = 16,
          },
        },
        commit_log_panel = {
          win_config = {},
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {
          disable_defaults = false,
          view = {
            { "n", "<tab>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle the file panel" } },
            { "n", "gf", "<cmd>DiffviewGoToFile<cr>", { desc = "Open the file in a new split" } },
            { "n", "<leader>e", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle the file panel" } },
            { "n", "<leader>co", "<cmd>DiffviewConflictChooseOurs<cr>", { desc = "Choose the OURS version" } },
            { "n", "<leader>ct", "<cmd>DiffviewConflictChooseTheirs<cr>", { desc = "Choose the THEIRS version" } },
            { "n", "<leader>cb", "<cmd>DiffviewConflictChooseBase<cr>", { desc = "Choose the BASE version" } },
            { "n", "<leader>ca", "<cmd>DiffviewConflictChooseAll<cr>", { desc = "Choose all the versions" } },
            { "n", "dx", "<cmd>DiffviewConflictChooseNone<cr>", { desc = "Delete the conflict region" } },
          },
          diff1 = {
            { "n", "g?", "<cmd>h diffview-maps-diff1<cr>", { desc = "Open the help panel" } }
          },
          diff2 = {
            { "n", "g?", "<cmd>h diffview-maps-diff2<cr>", { desc = "Open the help panel" } }
          },
          diff3 = {
            { "n", "g?", "<cmd>h diffview-maps-diff3<cr>", { desc = "Open the help panel" } },
            { { "n", "x" }, "2do", { desc = "Obtain diff hunk from OURS" } },
            { { "n", "x" }, "3do", { desc = "Obtain diff hunk from THEIRS" } },
          },
          diff4 = {
            { "n", "g?", "<cmd>h diffview-maps-diff4<cr>", { desc = "Open the help panel" } },
            { { "n", "x" }, "1do", { desc = "Obtain diff hunk from BASE" } },
            { { "n", "x" }, "2do", { desc = "Obtain diff hunk from OURS" } },
            { { "n", "x" }, "3do", { desc = "Obtain diff hunk from THEIRS" } },
          },
          file_panel = {
            { "n", "j", "<cmd>DiffviewNext<cr>", { desc = "Next file entry" } },
            { "n", "k", "<cmd>DiffviewPrev<cr>", { desc = "Previous file entry" } },
            { "n", "<cr>", "<cmd>DiffviewOpen<cr>", { desc = "Open the diff for selected entry" } },
            { "n", "o", "<cmd>DiffviewOpen<cr>", { desc = "Open the diff for selected entry" } },
            { "n", "l", "<cmd>DiffviewOpen<cr>", { desc = "Open the diff for selected entry" } },
            { "n", "-", "<cmd>DiffviewToggleStage<cr>", { desc = "Stage/unstage the selected entry" } },
            { "n", "S", "<cmd>DiffviewStageAll<cr>", { desc = "Stage all entries" } },
            { "n", "U", "<cmd>DiffviewUnstageAll<cr>", { desc = "Unstage all entries" } },
            { "n", "X", "<cmd>DiffviewRestoreEntry<cr>", { desc = "Restore entry to left side state" } },
            { "n", "L", "<cmd>DiffviewOpenCommitLog<cr>", { desc = "Open the commit log panel" } },
            { "n", "zo", "<cmd>DiffviewFoldOpen<cr>", { desc = "Expand fold" } },
            { "n", "h", "<cmd>DiffviewFoldClose<cr>", { desc = "Collapse fold" } },
            { "n", "zc", "<cmd>DiffviewFoldClose<cr>", { desc = "Collapse fold" } },
            { "n", "za", "<cmd>DiffviewFoldToggle<cr>", { desc = "Toggle fold" } },
            { "n", "zR", "<cmd>DiffviewFoldOpenAll<cr>", { desc = "Expand all folds" } },
            { "n", "zM", "<cmd>DiffviewFoldCloseAll<cr>", { desc = "Collapse all folds" } },
            { "n", "<tab>", "<cmd>DiffviewSelect<cr>", { desc = "Open diff for selected entry" } },
            { "n", "gf", "<cmd>DiffviewGoToFile<cr>", { desc = "Open file in new split" } },
            { "n", "i", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle the file panel" } },
            { "n", "f", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle the file panel" } },
            { "n", "g?", "<cmd>h diffview-maps-file-panel<cr>", { desc = "Open the help panel" } },
          },
          file_history_panel = {
            { "n", "g!", "<cmd>DiffviewOptionsToggle<cr>", { desc = "Options" } },
            { "n", "y", "<cmd>DiffviewYankHash<cr>", { desc = "Yank the commit hash" } },
            { "n", "L", "<cmd>DiffviewOpenCommitLog<cr>", { desc = "Show commit details" } },
            { "n", "X", "<cmd>DiffviewRestoreEntry<cr>", { desc = "Restore file to selected entry state" } },
            { "n", "j", "<cmd>DiffviewNext<cr>", { desc = "Next file entry" } },
            { "n", "k", "<cmd>DiffviewPrev<cr>", { desc = "Previous file entry" } },
            { "n", "<cr>", "<cmd>DiffviewOpen<cr>", { desc = "Open diff for selected entry" } },
            { "n", "o", "<cmd>DiffviewOpen<cr>", { desc = "Open diff for selected entry" } },
            { "n", "<tab>", "<cmd>DiffviewSelect<cr>", { desc = "Open diff for selected entry" } },
            { "n", "gf", "<cmd>DiffviewGoToFile<cr>", { desc = "Open file in new split" } },
            { "n", "i", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle the file panel" } },
            { "n", "f", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle the file panel" } },
            { "n", "g?", "<cmd>h diffview-maps-file-history-panel<cr>", { desc = "Open the help panel" } },
          },
          option_panel = {
            { "n", "<tab>", "<cmd>DiffviewSelect<cr>", { desc = "Change the current option" } },
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
            { "n", "<esc>", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          },
          help_panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
            { "n", "<esc>", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          },
        },
      })
    end,
  },
}