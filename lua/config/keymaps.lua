local k = vim.keymap
vim.g.mapleader = " "
--normal mode
--windows
k.set("n", "<leader>nh", ":nohl<CR>")

-- Run
-- 在 Neovim 中创建快捷键编译和运行 C++ 文件（Windows 版本）在终端中打开
--vim.api.nvim_set_keymap('n', '<F5>', ':w<CR>:terminal g++ "%:p" -o "%:p:r.exe" && start cmd /k "%:p:r.exe"<CR>', { noremap = true, silent = true })--直接开新窗口
--vim.api.nvim_set_keymap('n', '<F5>', ':w<CR>:vsp | term cmd /c "g++ %:p -o %:p:r.exe && %:p:r.exe"<CR>', { noremap = true, silent = true })
-- 解决路径中空格用双引号括起来""
-- 创建一个函数来处理通知和编译运行逻辑
--vim.api.nvim_set_keymap('n', '<F5>', ':w<CR>:lua vim.notify("编译并运行中...", "info", {title = "编译通知"})<CR>:lcd %:p:h<CR>:sp | term cmd.exe /c "g++ \"%:p\" -o \"%:p:r.exe\" && \"%:p:r.exe\""<CR>', { noremap = true, silent = true })
function CompileAndRun()
    -- 保存当前文件
    vim.cmd("write")

    -- 显示通知
    vim.notify("Compile and Run...", "info", {title = "Running"})

    -- 更改当前工作目录为文件所在目录
    vim.cmd("lcd %:p:h")

    -- 构建编译和运行的命令
    local compile_cmd = string.format("g++ \"%s\" -o \"%s\"", vim.fn.expand('%:p'), vim.fn.expand('%:p:r.exe'))
    local run_cmd = string.format("\"%s\"", vim.fn.expand('%:p:r.exe'))

    -- 水平分割窗口并打开终端，编译并运行当前文件
    vim.cmd(string.format("botright split | term cmd /c \"echo Compiling: %s && %s && echo Compilation successful && %s & pause\"", compile_cmd, compile_cmd, run_cmd))
end

-- 设置快捷键映射调用 Lua 函数
vim.api.nvim_set_keymap('n', '<F5>', ':lua CompileAndRun()<CR>', { noremap = true, silent = true })


-- tree

vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- 设置快捷键来切换到 nvim-tree 窗口
--vim.api.nvim_set_keymap('n', '<Leader>t', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

-- 设置快捷键来从 nvim-tree 窗口返回到上一个文件窗口
--vim.api.nvim_set_keymap('n', '<Leader>f', ':wincmd p<CR>', { noremap = true, silent = true })

-- Neogit
--vim.api.nvim_set_keymap('n', '<C-g>', ':silent Neogit<CR>', { noremap = true, silent = true }) --ctrl + g 打开
-- 创建一个函数来处理 Neogit 打开和通知逻辑
function OpenNeogit()
    vim.cmd("silent Neogit")
    vim.notify("Neogit 已打开", "info", {title = "Neogit 通知"})
end

-- 设置快捷键映射调用 Lua 函数
vim.api.nvim_set_keymap('n', '<C-g>', ':lua OpenNeogit()<CR>', { noremap = true, silent = true })


-- Competitivetest
vim.api.nvim_set_keymap('n', 'ca', ':CompetiTest add_testcase<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'cr', ':CompetiTest run<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ce', ':CompetiTest edit_testcase<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ct', ':CompetiTest receive testcases<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'cp', ':CompetiTest receive problem<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'cc', ':CompetiTest receive contest<CR>', { noremap = true, silent = true })
-- 设置快捷键为 <Leader>cd
vim.api.nvim_set_keymap('n', '<Leader>cd', ':lua ChangeDirectoryToCurrentFile()<CR>', { noremap = true, silent = true })

-- 定义函数 ChangeDirectoryToCurrentFile
function ChangeDirectoryToCurrentFile()
    local current_file_path = vim.fn.expand('%:p:h')
    vim.cmd('cd ' .. current_file_path)
    vim.notify('Current directory changed to: ' .. current_file_path, vim.log.levels.INFO)
end

vim.api.nvim_set_keymap('n', '<Leader>fb', ":Telescope file_browser<CR>", { noremap = true, silent = true })

-- 初始化字体大小
local default_font_size = 12
local current_font_size = default_font_size

-- 设置字体大小的函数
local function set_font_size(size)
    vim.opt.guifont = string.format("FiraCode Nerd Font:h%d", size)
end

-- 增大字体大小的函数
local function increase_font_size()
    current_font_size = current_font_size + 1
    set_font_size(current_font_size)
end

-- 减小字体大小的函数
local function decrease_font_size()
    current_font_size = current_font_size - 1
    set_font_size(current_font_size)
end

-- 绑定快捷键
vim.api.nvim_set_keymap("n", "<C-+>", ":lua increase_font_size()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-=>", ":lua increase_font_size()<CR>", { noremap = true, silent = true }) -- 处理键盘布局不同情况
vim.api.nvim_set_keymap("n", "<C-->", ":lua decrease_font_size()<CR>", { noremap = true, silent = true })

-- 设置初始字体大小
set_font_size(default_font_size)
