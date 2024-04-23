return {

	{
		"nvim-lua/plenary.nvim",
		name = "plenary",
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	{
		"echasnovski/mini.statusline",
		version = "*",
		opts = {},
	},

	{ "echasnovski/mini.ai", version = "*", opts = {} },
	{ "numToStr/Comment.nvim", opts = {} },
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
