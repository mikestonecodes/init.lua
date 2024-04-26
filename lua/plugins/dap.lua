local desc = function(str)
	return str
end
local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "stevearc/overseer.nvim", opts = { dap = false } },
		{
			"mxsdev/nvim-dap-vscode-js",
			{
				"microsoft/vscode-js-debug",
				version = "1.x",
				build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
			},
		},
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
			keys = {
				{
					"<leader>du",
					function()
						require("dapui").toggle({})
					end,
					desc = desc("Dap UI"),
				},
				{
					"<leader>de",
					function()
						require("dapui").eval()
					end,
					desc = desc("Eval"),
					mode = { "n", "v" },
				},
			},
			opts = {
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "console", size = 1 },
						},
						position = "bottom",
						size = 8,
					},
				},
			},
		},

		{ "theHamsta/nvim-dap-virtual-text", opts = {} },
		-- Lua adapter
	},
	keys = {
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = desc("Breakpoint Condition"),
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = desc("Toggle Breakpoint"),
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = desc("Continue"),
		},
		{
			"<leader>dC",
			function()
				require("dap").run_to_cursor()
			end,
			desc = desc("Run to Cursor"),
		},
		{
			"<leader>dg",
			function()
				require("dap").goto_()
			end,
			desc = desc("Go to line (no execute)"),
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = desc("Step Into"),
		},
		{
			"<leader>dj",
			function()
				require("dap").down()
			end,
			desc = desc("Down"),
		},
		{
			"<leader>dk",
			function()
				require("dap").up()
			end,
			desc = desc("Up"),
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = desc("Run Last"),
		},
		{
			"<leader>dO",
			function()
				require("dap").step_out()
			end,
			desc = desc("Step Out"),
		},
		{
			"<leader>do",
			function()
				require("dap").step_over()
			end,
			desc = desc("Step Over"),
		},
		{
			"<leader>dp",
			function()
				require("dap").pause()
			end,
			desc = desc("Pause"),
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.toggle()
			end,
			desc = desc("Toggle REPL"),
		},
		{
			"<leader>ds",
			function()
				require("dap").session()
			end,
			desc = desc("Session"),
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = desc("Terminate"),
		},
		{
			"<leader>dh",
			function()
				require("dap.ui.widgets").hover()
			end,
			desc = desc("Widgets"),
		},
		{
			"<leader>da",
			function()
				local dap = require("dap")
			    local launch_json = vim.fn.json_decode(vim.fn.readfile(".vscode/launch.json"))
				dap.run(launch_json.configurations[1],{new=true})
				dap.run(launch_json.configurations[2],{new=true})
				--require("dap").run(require("dap").configurations[vim.api.nvim_buf_get_option(0, "filetype")][1])
				--require("dap").run(require("dap").configurations[vim.api.nvim_buf_get_option(0, "filetype")][2])
				print("attached")
			end,
			desc = desc("Run with Args"),
		},
	},
	config = function()
		local icons = {
			Stopped = { "󰁕 ", "DiagnosticSignWarn", "DapStoppedLine" },
			Breakpoint = { " ", "DiagnosticSignInfo" },
			BreakpointCondition = { " ", "DiagnosticSignHint" },
			BreakpointRejected = { " ", "DiagnosticSignError" },
			LogPoint = ".>",
		}
		require("dap-vscode-js").setup({
			debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
			adapters = { "pwa-chrome" },
		})

		require("dap").adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}", --let both ports be the same for now...
			executable = {
				command = "node",
				-- -- 💀 Make sure to update this path to point to your installation
				args = {
					vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					"${port}",
				},
				-- command = "js-debug-adapter",
				-- args = { "${port}" },
			},
		}
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

		for name, sign in pairs(icons) do
			sign = type(sign) == "table" and sign or { sign }
			vim.fn.sign_define(
				"Dap" .. name,
				{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
			)
		end
		--require("dap").set_log_level("TRACE");
		--require("dap").defaults.fallback.exception_breakpoints = { "uncaught" }
		-- Use overseer for running preLaunchTask and postDebugTask.
		--require("overseer").patch_dap(true)

		-- Lua configurations.
	end,
}
