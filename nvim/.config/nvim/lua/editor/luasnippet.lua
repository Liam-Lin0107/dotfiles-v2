return function()
	local luasnip = require("luasnip")
	luasnip.setup({
		history = true,
		updateevents = "TextChanged,TextChangedI",
		delete_check_events = "TextChanged,InsertLeave",
	})

	-- let one file can use multiple snippet sources.
	-- luasnip.filetype_extend("typescriptreact", { "html" })

	require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets/" } })
	-- require("luasnip.loaders.from_vscode").load({ exclude = { "typescriptreact", "cs", "rust" } })

	-- key map
	local keymap = vim.keymap.set
	-- next
	keymap({ "i", "s" }, "<Tab>", function()
		if luasnip.jumpable(1) then
			luasnip.expand_or_jump(1)
		end
	end, { noremap = true, silent = true })
	-- prev
	keymap({ "i", "s" }, "<S-Tab>", function()
		if luasnip.jumpable(-1) then
			luasnip.jump(-1)
		end
	end, { noremap = false, silent = true })
end
