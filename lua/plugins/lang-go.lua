return {
  -- Instala automaticamente as ferramentas Go via Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "gopls",           -- Go LSP server
        "gofumpt",         -- Go formatter
        "goimports",       -- Go imports organizer
        "gomodifytags",    -- Go struct tag modifier (para gopher.nvim)
        "gotests",         -- Go test generator (para gopher.nvim)
        "impl",            -- Go interface implementer (para gopher.nvim)
        "iferr",           -- Go if err generator (para gopher.nvim)
        "delve",           -- Go debugger
      })
    end,
  },

  -- Configuração automática do mason-lspconfig para Go
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "gopls" })
    end,
  },

  -- Go LSP Configuration
  {
    "neovim/nvim-lspconfig",
    ft = { "go", "gomod", "gowork", "gotmpl" },
    config = function()
      local lspconfig = require("lspconfig")
      
      -- Get base capabilities and on_attach from global config
      local capabilities = _G.lsp_capabilities or require("cmp_nvim_lsp").default_capabilities()
      local base_on_attach = _G.lsp_base_on_attach or function() end

      -- Go-specific on_attach
      local function go_on_attach(client, bufnr)
        -- Call base on_attach first
        base_on_attach(client, bufnr)
        
        -- Go-specific keymaps
        local keymap = vim.keymap.set
        local opts = { buffer = bufnr, silent = true }
        
        -- Comandos Go usando as ferramentas instaladas pelo Mason
        keymap("n", "<leader>gf", function() vim.lsp.buf.format() end, vim.tbl_extend("force", opts, { desc = "Format Go file" }))
        keymap("n", "<leader>gi", function() vim.lsp.buf.code_action() end, vim.tbl_extend("force", opts, { desc = "Go code actions" }))
        keymap("n", "<leader>gt", "<cmd>!go test ./...<cr>", vim.tbl_extend("force", opts, { desc = "Run Go tests" }))
        keymap("n", "<leader>gr", "<cmd>!go run %<cr>", vim.tbl_extend("force", opts, { desc = "Run Go file" }))
        keymap("n", "<leader>gb", "<cmd>!go build<cr>", vim.tbl_extend("force", opts, { desc = "Build Go project" }))
        keymap("n", "<leader>gm", "<cmd>!go mod tidy<cr>", vim.tbl_extend("force", opts, { desc = "Go mod tidy" }))
        
        -- Auto format e imports on save
        if client.supports_method("textDocument/formatting") then
          local format_group = vim.api.nvim_create_augroup("GoFormat", { clear = false })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = format_group,
            buffer = bufnr,
            callback = function()
              -- Organizar imports primeiro
              local params = vim.lsp.util.make_range_params()
              params.context = {only = {"source.organizeImports"}}
              local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
              for _, res in pairs(result or {}) do
                for _, action in pairs(res.result or {}) do
                  if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                  end
                end
              end
              -- Depois formatar
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end

      -- Setup gopls
      lspconfig.gopls.setup({
        capabilities = capabilities,
        on_attach = go_on_attach,
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
              shadow = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
          },
        },
      })
    end,
  },

  -- Alternativa ao go.nvim: gopher.nvim (muito mais leve e estável)
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>gsj", "<cmd>GoTagAdd json<cr>", desc = "Add json struct tags" },
      { "<leader>gsy", "<cmd>GoTagAdd yaml<cr>", desc = "Add yaml struct tags" },
      { "<leader>gsr", "<cmd>GoTagRm<cr>", desc = "Remove struct tags" },
      { "<leader>gee", "<cmd>GoIfErr<cr>", desc = "Generate if err" },
      { "<leader>gfs", "<cmd>GoFillStruct<cr>", desc = "Fill struct" },
      { "<leader>gim", "<cmd>GoImpl<cr>", desc = "Implement interface" },
    },
    config = function()
      require("gopher").setup({
        commands = {
          go = "go",
          gomodifytags = "gomodifytags",
          gotests = "gotests",
          impl = "impl",
          iferr = "iferr",
        },
      })
    end,
  },

  -- Go debugging
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      { "<leader>gtd", function() require("dap-go").debug_test() end, desc = "Debug Go test" },
      { "<leader>gdd", function() require("dap-go").debug_last_test() end, desc = "Debug last test" },
    },
    config = function()
      require("dap-go").setup({
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        delve = {
          path = "dlv",
          initialize_timeout_sec = 20,
          port = "${port}",
          args = {},
          build_flags = "",
        },
      })
    end,
  },

  -- Go testing com neotest
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
    },
    ft = "go",
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
      { "<leader>tp", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Run project tests" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show test output" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=60s", "-race" }
          }),
        },
      })
    end,
  },

  -- Treesitter para Go
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
        "gotmpl",
      })
      return opts
    end,
  },

  -- Comentários específicos para Go
  {
    "numToStr/Comment.nvim",
    opts = function(_, opts)
      local ft = require("Comment.ft")
      ft.go = {"//%s", "/*%s*/"}
      return opts
    end,
  },
}