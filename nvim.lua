-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions.
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.keymap.set("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

vim.lsp.enable('denols')
vim.lsp.enable('lua_ls')
vim.lsp.enable('nixd')
vim.lsp.enable('pylsp')
vim.lsp.enable('rust_analyzer')

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
vim.opt.autochdir = true
vim.opt.matchpairs = '(:),{:},[:],<:>'
vim.opt.foldmethod = 'syntax'
vim.opt.foldenable = false
vim.opt.modeline = false -- for security
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 30
vim.g.loaded_perl_provider = false
vim.g.dracula_colorterm = false
vim.g.strip_whitespace_on_save = true
vim.g.strip_whitespace_confirm = false
vim.g.strip_whitelines_at_eof = true
vim.g.rustfmt_autosave = true
vim.g.markdown_fenced_languages = {
	"ts=typescript"
}

vim.api.nvim_command([[autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif]])
vim.api.nvim_command('colorscheme dracula')

-- Jump to the last position.
vim.api.nvim_command([[autocmd BufReadPost * if line2byte(line("$") + 1) <= 1000000 && line("'\"") >= 1 && line("'\"") <= line("$") | execute 'normal! g`"' | endif]])

vim.api.nvim_set_keymap('n', 'tn', [[:tabnew<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', 'tt', [[:tabedit ]], { noremap = true })
