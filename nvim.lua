local nvim_lsp = require('lspconfig')

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions.
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.keymap.set("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

-- Use an on_attach function to only map the following keys after the language
-- server attaches to the current buffer.
local on_attach = function(client, bufnr)
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- Enable completion triggered by <c-x><c-o>.
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	buf_set_option("formatexpr", "v:lua.vim.lsp.formatexpr")
	buf_set_option("tagfunc", "v:lua.vim.lsp.tagfunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions.
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
	vim.keymap.set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", bufopts)
	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
	vim.keymap.set("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", bufopts)
	vim.keymap.set("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", bufopts)
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
	vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
	vim.keymap.set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", bufopts)
	vim.keymap.set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", bufopts)
	vim.keymap.set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", bufopts)
	vim.keymap.set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", bufopts)
	vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", bufopts)
	vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
	vim.keymap.set("n", "<space>f", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", bufopts)

	vim.api.nvim_command("augroup LSP")
	vim.api.nvim_command("autocmd!")
	if client.server_capabilities.document_highlight then
		vim.api.nvim_command("autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()")
		vim.api.nvim_command("autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()")
		vim.api.nvim_command("autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()")
	end
	vim.api.nvim_command("augroup END")
	--vim.api.nvim_command([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]])
end

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches
nvim_lsp.denols.setup {
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
	},
}
nvim_lsp.pylsp.setup {
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
	},
}
nvim_lsp.nixd.setup {
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
	},
}
nvim_lsp.rust_analyzer.setup {
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
	},
}
nvim_lsp.lua_ls.setup {
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
	},
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
		},
	},
}

vim.opt.expandtab = false
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
vim.api.nvim_command('filetype plugin indent on')
vim.api.nvim_command('syntax on')
vim.api.nvim_command('colorscheme dracula')

-- Jump to the last position.
vim.api.nvim_command([[autocmd BufReadPost * if line2byte(line("$") + 1) <= 1000000 && line("'\"") >= 1 && line("'\"") <= line("$") | execute 'normal! g`"' | endif]])

vim.api.nvim_set_keymap('n', 'tn', [[:tabnew<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', 'tt', [[:tabedit ]], { noremap = true })
