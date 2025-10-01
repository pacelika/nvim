return {
	{"kevinhwang91/promise-async"},
	{
	  'Wansmer/treesj',
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		config = function()
			require("nvim-surround").setup({})
		end,
        event = "BufReadPost"
	},
}
