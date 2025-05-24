local dap = require "dap"

if not dap then return print "dap is not installed" end

local dap_ui = require "dapui"

dap_ui.setup()

if not dap_ui then return print "dap ui is not installed" end

dap.set_log_level("TRACE")

dap.listeners.before.attach.dapui_config = dap_ui.open
dap.listeners.before.launch.dapui_config = dap_ui.open
dap.listeners.before.event_terminated.dapui_config = dap_ui.close
dap.listeners.before.event_exited.dapui_config = dap_ui.close

vim.keymap.set('n', '<Space>dr', dap.continue, { desc = 'Debug dap continue' })
vim.keymap.set('n', '<Space>dq', dap.terminate, { desc = 'Debug dap terminate' })
vim.keymap.set('n', '<Space>d.', dap.toggle_breakpoint, { desc = 'Debug dap toggle breakpoint' })

vim.keymap.set('n', '<Space>dn', dap.step_into, { desc = 'Debug dap step into' })
vim.keymap.set('n', '<Space>dp', dap.step_out, { desc = 'Debug dap step out' })
vim.keymap.set('n', '<Space>do', dap.step_over, { desc = 'Debug dap step out' })
