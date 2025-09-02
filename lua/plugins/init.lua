return {
  -- Colorscheme (loaded first)
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { 
            wave = {}, 
            lotus = {}, 
            dragon = {}, 
            all = {
              ui = {
                bg_gutter = "none"
              }
            }
          }
        },
        overrides = function(colors)
          return {}
        end,
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = {
          dark = "wave", -- try "dragon" !
          light = "lotus"
        },
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },

  -- Plenary (dependency for many plugins)
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Load plugin modules
  { import = "plugins.lsp" },
  { import = "plugins.lang-go" },
  { import = "plugins.lang-python" },
  { import = "plugins.coding" },
  { import = "plugins.editor" },
  { import = "plugins.ui" },
  { import = "plugins.git" },
}