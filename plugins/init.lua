return {
  -- Install plugin
  -- ["neoclide/coc.nvim"] = { branch: "release"}
  ["williamboman/mason.nvim"] = {},
  ["github/copilot.vim"] = { branch = "release" },

  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },

  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "custom.plugins.null-ls"
    end,
  },

  ["iamcco/markdown-preview.nvim"] = {
    run = "cd app && yarn install",
  },

  ["MaxMEllon/vim-jsx-pretty"] = {}

  -- ["iamcco/markdown-preview.nvim"] = {
  -- run = "function() vim.fn["mkdp#util#install"]() end",
  -- }
}
