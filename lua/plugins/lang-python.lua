return {
  -- Install Python tools via Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "black",
        "isort",
        "flake8",
        "mypy",
        "debugpy",
      })
    end,
  },

  -- Python LSP Configuration
  {
    "neovim/nvim-lspconfig",
    ft = "python",
    config = function()
      local lspconfig = require("lspconfig")
      
      -- Get base capabilities and on_attach from global config
      local capabilities = _G.lsp_capabilities or require("cmp_nvim_lsp").default_capabilities()
      local base_on_attach = _G.lsp_base_on_attach or function() end

      -- Python-specific on_attach
      local function python_on_attach(client, bufnr)
        -- Call base on_attach first
        base_on_attach(client, bufnr)
        
        -- Python-specific keymaps
        local keymap = vim.keymap.set
        local opts = { buffer = bufnr, silent = true }
        
        keymap("n", "<leader>pr", "<cmd>!python %<cr>", vim.tbl_extend("force", opts, { desc = "Python: Run file" }))
        keymap("n", "<leader>pt", "<cmd>!python -m pytest %<cr>", vim.tbl_extend("force", opts, { desc = "Python: Run tests" }))
        
        -- Auto format on save for Python files
        if client.supports_method("textDocument/formatting") then
          local format_group = vim.api.nvim_create_augroup("PythonFormat", { clear = false })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = format_group,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end

      -- Setup pyright
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = python_on_attach,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
            },
          },
        },
      })
    end,
  },

  -- Python virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    branch = "regexp",
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python Virtual Environment" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached Venv" },
    },
    config = function()
      require("venv-selector").setup({
        settings = {
          options = {
            notify_user_on_venv_activation = true,
          },
          search = {
            anaconda_base = {
              command = "fd python$ ~/anaconda3/bin --full-path --color never",
              type = "anaconda"
            },
            anaconda_envs = {
              command = "fd python$ ~/anaconda3/envs --full-path --color never",
              type = "anaconda"
            },
            pyenv = {
              command = "fd python$ ~/.pyenv/versions --full-path --color never",
              type = "pyenv"
            },
            pipenv = {
              command = "pipenv --venv",
              type = "pipenv"
            },
            poetry = {
              command = "poetry env info -p",
              type = "poetry"
            },
            venv = {
              command = "fd python$ . --type x --full-path --color never",
              type = "venv"
            },
          },
        },
      })
    end,
  },

  -- Python testing with neotest
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    ft = "python",
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
            python = function()
              -- Try to use the current virtual environment
              local venv = os.getenv("VIRTUAL_ENV")
              if venv then
                return venv .. "/bin/python"
              end
              return "python"
            end,
          }),
        },
      })
    end,
  },

  -- Python docstring generator
  {
    "danymat/neogen",
    ft = "python",
    keys = {
      { "<leader>nf", function() require("neogen").generate({ type = "func" }) end, desc = "Generate function docstring" },
      { "<leader>nc", function() require("neogen").generate({ type = "class" }) end, desc = "Generate class docstring" },
    },
    config = function()
      require("neogen").setup({
        snippet_engine = "luasnip",
        languages = {
          python = {
            template = {
              annotation_convention = "google_docstrings",
            },
          },
        },
      })
    end,
  },

  -- Python REPL integration
  {
    "Vigemus/iron.nvim",
    ft = "python",
    keys = {
      { "<leader>rs", function() require("iron.core").send_line() end, desc = "Send line to REPL" },
      { "<leader>rf", function() require("iron.core").send_file() end, desc = "Send file to REPL" },
      { "<leader>rr", function() require("iron.core").repl_restart() end, desc = "Restart REPL" },
      { "<leader>ro", function() require("iron.core").repl_open() end, desc = "Open REPL" },
      { "<leader>rs", function() require("iron.core").send_motion() end, mode = "v", desc = "Send selection to REPL" },
    },
    config = function()
      local iron = require("iron.core")
      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { "python3" },
              format = require("iron.fts.common").bracketed_paste_python,
            },
          },
          repl_open_cmd = require("iron.view").bottom(40),
        },
        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_mark = "<space>sm",
          send_paragraph = "<space>sp",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        highlight = {
          italic = true
        },
        ignore_blank_lines = true,
      })
    end,
  },

  -- Python import sorting
  {
    "stsewd/isort.nvim",
    ft = "python",
    build = ":UpdateRemotePlugins",
    keys = {
      { "<leader>pi", "<cmd>Isort<cr>", desc = "Sort Python imports" },
    },
    config = function()
      vim.g.isort_command = "python -m isort"
    end,
  },

  -- Python-specific snippets and utilities
  {
    "roobert/f-string-toggle.nvim",
    ft = "python",
    keys = {
      { "<leader>pf", function() require("f-string-toggle").toggle() end, desc = "Toggle f-string" },
    },
    config = function()
      require("f-string-toggle").setup({
        key_binding = "<leader>pf",
        key_binding_desc = "Toggle f-string",
      })
    end,
  },
}