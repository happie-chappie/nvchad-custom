-- lua/custom/mappings 
local M = {}

-- add this table only when you want to disable default keys
M.disabled = {
  n = {
      ["<leader>h"] = "",
      ["<C-s>"] = ""
  }
}

M.abc = {

  n = {
     ["<C-n>"] = {"<cmd> Telescope <CR>", "Open Telescope"},
     ["<leader>vv"] = { "<cmd> lua vim.diagnostic.open_float()  <CR>", "   toggle nvimtree" },
  },

  i = {
    -- more keys!
  }
}

M.xyz = {
  -- stuff
}

return M
