return {
    {
        "goolord/alpha-nvim",
    },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},

	{"kevinhwang91/promise-async"},

	{
		"kylechui/nvim-surround",
		version = "*",
		event = "InsertEnter",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
}
