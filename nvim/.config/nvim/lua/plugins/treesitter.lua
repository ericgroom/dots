return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"typescript",
				"javascript",
				"nix",
				"elixir",
				"heex",
				"eex",
				"html",
				"swift",
				"caddy",
			}
			local treesitter = require("nvim-treesitter")
			treesitter.install(ensure_installed)

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					-- Only start if a parser and highlight query are actually found
					if lang and vim.treesitter.query.get(lang, "highlights") then
						pcall(vim.treesitter.start, args.buf, lang)
					end
				end,
			})
		end,
	},
}
