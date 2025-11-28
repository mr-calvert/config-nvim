-- MINE:
-- Enable spell checking on spell_types files
local spell_types = { "text", "plaintext", "gitcommit", "markdown", "md" }
vim.opt.spell = false
vim.api.nvim_create_augroup("Spellcheck", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "Spellcheck",
	pattern = spell_types,
	callback = function()
		vim.opt_local.spell = true
	end,
	desc = "Enable spellcheck only for defined types",
})
