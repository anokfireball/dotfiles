return {
	"rcarriga/nvim-notify",
	opts = {
		fps = 144,
		minimum_width = 1,
		render = "wrapped-compact",
		stages = "fade",
		timeout = 5000,
		top_down = true,
	},
    config = function(ctx) 
        require("notify").setup(ctx.opts)
        vim.notify = require("notify")
    end,
}
