return {
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				colors = {
					bg1 = "#31353f",
					bg2 = "#353b45",
					bg3 = "#373b43",
					bg_d = "#21252b",
					bg_blue = "#81A1C1",
					bg_yellow = "#EBCB8B",
					fg = "#abb2bf",
					purple = "#de98fd",
					green = "#98c379",
					orange = "#fca2aa",
					blue = "#61afef",
					yellow = "#e7c787",
					cyan = "#a3b8ef",
					red = "#e06c75",
					grey = "#42464e",
					light_grey = "#6f737b",
					dark_cyan = "#519ABA",
					dark_red = "#e06c75",
					dark_yellow = "#e7c787",
					dark_purple = "#c882e7",
					diff_add = "#98c379",
					diff_delete = "#e06c75",
					diff_change = "#61afef",
					diff_text = "#EBCB8B",
				},
				transparent = true,
				highlights  = {
					["@tag"] = { fg = "$red"},
					["@tag.delimiter"] = { fg="$light_grey" },
					["@punctuation.special"] = { fg="$light_grey" }
				},
				style = "darker",
			})
			require("onedark").load()
		end,
	},
}
