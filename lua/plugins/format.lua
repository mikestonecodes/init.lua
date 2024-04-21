return {
	{
		"stevearc/conform.nvim",
		after = { "mason" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				rust = { "rustfmt" },
				javascript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				typescript = { "biome" },
				json = { "biome" },
				yaml = { "biome" },
				markdown = { "biome" },
				toml = { "taplo" },
				go = { "goimports", "gofmt" },
				sh = { "shfmt" },
			},
			formatters = {
				goimports = {
					prepend_args = { "-local", "github.com/xwjdsh" },
				},
			},
		},
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format()
				end,
				desc = "format",
			},
		},
	},
	{
		"zapling/mason-conform.nvim",
		after = { "mason", "conform" },
		opts = {},
	},
}
