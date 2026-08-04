-- netcoredbg: on macOS/ARM the prebuilt binary comes from a plugin, since
-- upstream ships no Apple Silicon build. Elsewhere it's a system package
-- (`pacman -S netcoredbg` on Arch) found via exepath.
local is_mac = vim.uv.os_uname().sysname == "Darwin"

local specs = {
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
}
if is_mac then
	table.insert(specs, { src = "https://github.com/Cliffback/netcoredbg-macOS-arm64.nvim" })
end

table.insert(specs, {
	src = "https://github.com/mfussenegger/nvim-dap",
	setup = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Signs
		vim.fn.sign_define("DapBreakpoint", { text = "■", texthl = "DapBreakpoint" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "◈", texthl = "DapBreakpointCondition" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "◇", texthl = "DapBreakpointRejected" })
		vim.fn.sign_define("DapLogPoint", { text = "▤", texthl = "DapLogPoint" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine" })

		dapui.setup()

		-- .NET Core debug adapter (plugin path is the vim.pack directory)
		local netcoredbg_path = is_mac
				and vim.fn.stdpath("data") .. "/site/pack/core/opt/netcoredbg-macOS-arm64.nvim/netcoredbg/netcoredbg"
			or vim.fn.exepath("netcoredbg")

		if netcoredbg_path ~= "" then
			dap.adapters.coreclr = {
				type = "executable",
				command = netcoredbg_path,
				args = { "--interpreter=vscode" },
			}
		end

		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "Launch: ask for dll",
				request = "launch",
				program = function()
					return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
				end,
				cwd = function()
					return vim.fn.getcwd()
				end,
				stopAtEntry = false,
			},
		}

		-- Open/close dap-ui automatically
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Keymaps
		local map = vim.keymap.set

		-- Session
		map("n", "<leader>dc", dap.continue, { desc = "Start / Continue" })
		map("n", "<leader>dq", dap.terminate, { desc = "Stop" })
		map("n", "<leader>dR", dap.restart, { desc = "Restart" })

		-- Stepping
		map("n", "<leader>do", dap.step_over, { desc = "Step over" })
		map("n", "<leader>di", dap.step_into, { desc = "Step into" })
		map("n", "<leader>dO", dap.step_out, { desc = "Step out" })
		map("n", "<leader>dl", dap.run_to_cursor, { desc = "Run to cursor" })

		-- Breakpoints
		map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		map("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Condition: "))
		end, { desc = "Conditional breakpoint" })
		map("n", "<leader>dL", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
		end, { desc = "Log point" })
		map("n", "<leader>dx", dap.clear_breakpoints, { desc = "Clear all breakpoints" })

		-- Inspection
		map("n", "<leader>dh", require("dap.ui.widgets").hover, { desc = "Hover variable" })
		map("v", "<leader>dh", require("dap.ui.widgets").hover, { desc = "Hover selection" })
		map("n", "<leader>de", dapui.eval, { desc = "Eval expression" })
		map("v", "<leader>de", dapui.eval, { desc = "Eval selection" })

		-- UI
		map("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
		map("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
	end,
})

return specs
