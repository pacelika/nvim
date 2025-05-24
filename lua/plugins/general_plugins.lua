return {
	{"kevinhwang91/promise-async"},
    -- {
    --     "vhyrro/luarocks.nvim",
    --     priority = 1001,
    --     opts = {
    --         rocks = { "magick" },
    --     },
    -- },

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
	},
}
