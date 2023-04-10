return function()
	-- add servers
	local servers = require("core").lsp_servers
	-- connected mason and lspconfig
	require("mason-lspconfig").setup({
		ensure_installed = servers,
		automatic_installation = true,
	})

	-- set behavior for specific buffer
	local function on_attach(client, bufnr)
		-- set keymap
		local opts = { noremap = true, silent = true }
		local keymap = vim.api.nvim_buf_set_keymap
		keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
		-- keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

		-- Format
		vim.cmd([[command! Format execute "lua vim.lsp.buf.format({ async = true })" ]]) -- Format command
		-- formatting before save
		vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])

		-- add some plugin

		require("illuminate").on_attach(client)
		require("lsp_signature").on_attach({ -- plugin for parameter hint
			bind = true,
			handler_opts = {
				border = "rounded",
			},
			hint_enable = false,
		}, bufnr)

		vim.keymap.set({ "n" }, "<Leader>k", function()
			vim.lsp.buf.signature_help()
		end, { silent = true, noremap = true, desc = "toggle signature" })

		-- add some capabilities filters
		if client.name == "lua_ls" then
			client.server_capabilities.documentFormattingProvider = false
		end
		if client.name == "tsserver" then
			client.server_capabilities.documentFormattingProvider = false
		end
		if client.name == "pyright" then
			client.server_capabilities.documentFormattingProvider = false
		end
		if client.name == "pylsp" then
			client.server_capabilities.documentFormattingProvider = false
		end
	end

	-- capabilities
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities) -- add to cmp

	-- auto register lsp service
	for _, server in ipairs(servers) do
		local opts = {
			capabilities = capabilities,
			on_attach = on_attach,
		}
		-- find ./setting
		local require_ok, conf_opts = pcall(require, "services.settings." .. server) -- for the settings folder
		if require_ok then
			opts = vim.tbl_deep_extend("force", conf_opts, opts) -- merge two table with force mode.
		end

		require("lspconfig")[server].setup(opts)
	end

	-- setup diagnostic ui
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	vim.diagnostic.config({
		virtual_text = { spacing = 2, prefix = "●" }, -- show diagnostic after your code
		signs = {
			active = signs, -- show signs
		},
		update_in_insert = true,
		underline = true, -- underline for diagnostic
		severity_sort = true,
		float = {
			-- the diagnostic window
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})
end
