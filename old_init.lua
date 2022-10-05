vim.cmd "highlight Normal guibg=none guifg=none"
vim.cmd "set mouse=r"
vim.cmd "autocmd CursorHold * silent! checktime"

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	float = {
		border = "single",
		format = function(diagnostic)
			return string.format(
				"%s (%s) [%s]",
				diagnostic.message,
				diagnostic.source,
				diagnostic.code or diagnostic.user_data.lsp.code
			)
		end,
	},
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- Some servers have issues with backup files, see #649.
-- vim.opt.backup = false
-- vim.opt.writebackup = false
-- 
-- -- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- -- delays and poor user experience.
-- vim.opt.updatetime = 300
-- 
-- -- Always show the signcolumn, otherwise it would shift the text each time
-- -- diagnostics appear/become resolved.
-- vim.opt.signcolumn = "yes"
-- 
-- local keyset = vim.keymap.set
-- -- Auto complete
-- function _G.check_back_space()
--     local col = vim.fn.col('.') - 1
--     return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
-- end
-- 
-- -- Use tab for trigger completion with characters ahead and navigate.
-- -- NOTE: There's always complete item selected by default, you may want to enable
-- -- no select by `"suggest.noselect": true` in your configuration file.
-- -- NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
-- -- other plugin before putting this into your config.
-- local opts = {silent = true, noremap = true, expr = true}
-- keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
-- keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
-- 
-- -- Make <CR> to accept selected completion item or notify coc.nvim to format
-- -- <C-g>u breaks current undo, please make your own choice.
-- keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
-- 
-- -- Use <c-j> to trigger snippets
-- keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- -- Use <c-space> to trigger completion.
-- keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})
-- 
-- -- Use `[g` and `]g` to navigate diagnostics
-- -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
-- keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
-- keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})
-- 
-- -- GoTo code navigation.
-- keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
-- keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
-- keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
-- keyset("n", "gr", "<Plug>(coc-references)", {silent = true})
-- 
-- 
-- -- Use K to show documentation in preview window.
-- function _G.show_docs()
--     local cw = vim.fn.expand('<cword>')
--     if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
--         vim.api.nvim_command('h ' .. cw)
--     elseif vim.api.nvim_eval('coc#rpc#ready()') then
--         vim.fn.CocActionAsync('doHover')
--     else
--         vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
--     end
-- end
-- keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})
-- 
-- 
-- -- Highlight the symbol and its references when holding the cursor.
-- vim.api.nvim_create_augroup("CocGroup", {})
-- vim.api.nvim_create_autocmd("CursorHold", {
--     group = "CocGroup",
--     command = "silent call CocActionAsync('highlight')",
--     desc = "Highlight symbol under cursor on CursorHold"
-- })
-- 
-- 
-- -- Formatting selected code.
-- keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
-- keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
-- 
-- 
-- -- Setup formatexpr specified filetype(s).
-- vim.api.nvim_create_autocmd("FileType", {
--     group = "CocGroup",
--     pattern = "typescript,json",
--     command = "setl formatexpr=CocAction('formatSelected')",
--     desc = "Setup formatexpr specified filetype(s)."
-- })
-- 
-- -- Update signature help on jump placeholder.
-- vim.api.nvim_create_autocmd("User", {
--     group = "CocGroup",
--     pattern = "CocJumpPlaceholder",
--     command = "call CocActionAsync('showSignatureHelp')",
--     desc = "Update signature help on jump placeholder"
-- })
-- 
-- 
-- -- Applying codeAction to the selected region.
-- -- Example: `<leader>aap` for current paragraph
-- local opts = {silent = true, nowait = true}
-- keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
-- keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
-- 
-- -- Remap keys for applying codeAction to the current buffer.
-- keyset("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)
-- 
-- 
-- -- Apply AutoFix to problem on the current line.
-- keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)
-- 
-- 
-- -- Run the Code Lens action on the current line.
-- keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)
-- 
-- 
-- -- Map function and class text objects
-- -- NOTE: Requires 'textDocument.documentSymbol' support from the language server.
-- keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
-- keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
-- keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
-- keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
-- keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
-- keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
-- keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
-- keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)
-- 
-- 
-- -- Remap <C-f> and <C-b> for scroll float windows/popups.
-- ---@diagnostic disable-next-line: redefined-local
-- local opts = {silent = true, nowait = true, expr = true}
-- keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
-- keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
-- keyset("i", "<C-f>",
--        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
-- keyset("i", "<C-b>",
--        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
-- keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
-- keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
-- 
-- 
-- -- Use CTRL-S for selections ranges.
-- -- Requires 'textDocument/selectionRange' support of language server.
-- keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
-- keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
-- 
-- 
-- -- Add `:Format` command to format current buffer.
-- vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
-- 
-- -- " Add `:Fold` command to fold current buffer.
-- vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})
-- 
-- -- Add `:OR` command for organize imports of the current buffer.
-- vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
-- 
-- -- Add (Neo)Vim's native statusline support.
-- -- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- -- provide custom statusline: lightline.vim, vim-airline.
-- vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")
-- 
-- -- Mappings for CoCList
-- -- code actions and coc stuff
-- ---@diagnostic disable-next-line: redefined-local
-- local opts = {silent = true, nowait = true}
-- -- Show all diagnostics.
-- keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
-- -- Manage extensions.
-- keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
-- -- Show commands.
-- keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
-- -- Find symbol of current document.
-- keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
-- -- Search workspace symbols.
-- keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
-- -- Do default action for next item.
-- keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
-- -- Do default action for previous item.
-- keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
-- -- Resume latest coc list.
-- keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
