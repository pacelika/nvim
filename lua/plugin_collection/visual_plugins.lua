return {
	{ 
        "nvim-tree/nvim-web-devicons", 
        event = "VeryLazy" 
    },

	{
		"folke/todo-comments.nvim",
		event = "InsertEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}
