local desc = function(str)
	return str
end
local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	config = vim.deepcopy(config)

	---@cast args string[]
	config.args = function()
		---@diagnostic disable-next-line: redundant-parameter
		local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
		return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
	end

	return config
end

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "stevearc/overseer.nvim", opts = { dap = false } },
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
		-- vscode-js-debug adapter
		{
			"microsoft/vscode-js-debug",
			build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
		},
		{
			"mxsdev/nvim-dap-vscode-js",
			opts = {
				debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
				adapters = { "pwa-node" },
			},
		},
		{ "theHamsta/nvim-dap-virtual-text", opts = {} },
		-- Lua adapter
		{
			"jbyuki/one-small-step-for-vimkind",
			keys = {
				{
					"<leader>dL",
					function()
						require("osv").launch({ port = 8086 })
					end,
					desc = desc("Launch Lua adapter"),
				},
				{
					"<leader>dT",
					function()
						require("osv").run_this()
					end,
					desc = desc("Lua adapter: Run this"),
				},
			},
		},
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
				if vim.fn.filereadable(".vscode/launch.json") then
					local dap_vscode = require("dap.ext.vscode")
					dap_vscode.json_decode = require("overseer.json").decode
					dap_vscode.load_launchjs(nil, {
						["firefox"] = js_based_languages,
						["pwa-node"] = js_based_languages,
					})
				end
				require("dap").continue({ before = get_args })
			end,
			desc = desc("Run with Args"),
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local icons = {
			Stopped = { "󰁕 ", "DiagnosticSignWarn", "DapStoppedLine" },
			Breakpoint = { " ", "DiagnosticSignInfo" },
			BreakpointCondition = { " ", "DiagnosticSignHint" },
			BreakpointRejected = { " ", "DiagnosticSignError" },
			LogPoint = ".>",
		}
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({})
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close({})
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close({})
		end

		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

		for name, sign in pairs(icons) do
			sign = type(sign) == "table" and sign or { sign }
			vim.fn.sign_define(
				"Dap" .. name,
				{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
			)
		end

		-- Use overseer for running preLaunchTask and postDebugTask.
		require("overseer").patch_dap(true)

		-- Lua configurations.
		dap.adapters.nlua = function(callback, config)
			callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
		end

		require("dap").adapters.firefox = {
			type = "executable",
			command = "node",
			port = 9222,
			args = {
				require("mason-registry").get_package("firefox-debug-adapter"):get_install_path()
					.. "/dist/adapter.bundle.js",
			},
		}
		dap.configurations["lua"] = {
			{
				type = "nlua",
				request = "attach",
				name = "Attach to running Neovim instance",
				host = "127.0.0.1",
			},
		}
	end,
}
