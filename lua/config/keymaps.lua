local k = vim.keymap
vim.g.mapleader = " "

-- Normal mode
-- Clear search highlights
k.set("n", "<leader>nh", ":nohl<CR>")

-- 创建一个函数来编译并运行 C++ 文件（Windows 版本）
function CompileAndRun()
    -- 保存当前文件
    vim.cmd("write")

    vim.cmd("lcd %:p:h")

    local compile_cmd = string.format("g++ -std=c++20 \"%s\" -o \"%s.exe\"", vim.fn.expand('%:p'), vim.fn.expand('%:p:r'))
    local run_cmd = string.format("\"%s.exe\"", vim.fn.expand('%:p:r'))

    -- 尝试编译
    local compile_result = vim.fn.system(compile_cmd)

    -- 判断编译是否成功
    if vim.v.shell_error == 0 then
        -- 打开终端运行程序
        vim.cmd(string.format("vsplit | term cmd /c \"%s\"", run_cmd))
    else
        -- 编译失败，显示错误信息并不打开新窗口
        vim.notify("Compilation failed", "error", {title = "Error", timeout = 300})
    end
end


-- 创建一个函数来编译并运行 C++ 文件（Linux 版本）
function CompileAndRunLinux()
    -- 保存当前文件
    vim.cmd("write")

    -- 更改当前工作目录为文件所在目录
    vim.cmd("lcd %:p:h")

    -- 获取文件的完整路径
    local file_path = vim.fn.expand('%:p')
    local file_name_without_ext = vim.fn.expand('%:p:r')

    -- 构建编译命令
    local compile_cmd = string.format("g++ -std=c++20 \"%s\" -o \"%s\"", file_path, file_name_without_ext)

    -- 构建运行命令
    local run_cmd = string.format("./%s", file_name_without_ext)

    -- 尝试编译
    local compile_result = vim.fn.system(compile_cmd)

    -- 判断编译是否成功
    if vim.v.shell_error == 0 then
        -- 编译成功，给生成的可执行文件添加执行权限
        vim.fn.system(string.format("chmod +x \"%s\"", file_name_without_ext))

        -- 打开终端运行程序
        vim.cmd(string.format("vsplit | term bash -c \"%s\"", run_cmd))
    else
        -- 编译失败，显示错误信息并不打开新窗口
        vim.notify("Compilation failed", "error", {title = "Error", timeout = 300})
    end
end



-- 根据操作系统选择合适的编译运行方式
if vim.fn.has('unix') == 1 then
    -- 在 Linux 上绑定 F5 键
    vim.api.nvim_set_keymap('n', '<F5>', ':lua CompileAndRunLinux()<CR>', { noremap = true, silent = true })
else
    -- 在 Windows 上绑定 F5 键
    vim.api.nvim_set_keymap('n', '<F5>', ':lua CompileAndRun()<CR>', { noremap = true, silent = true })
end

-- Tree
-- 切换 NvimTree 文件管理窗口
vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Neogit
-- 创建一个函数来打开 Neogit 并显示通知
function OpenNeogit()
    vim.cmd("silent Neogit")
    vim.notify("Neogit 已打开", "info", {title = "Neogit 通知"})
end

-- 设置快捷键映射调用 Lua 函数
vim.api.nvim_set_keymap('n', '<C-g>', ':lua OpenNeogit()<CR>', { noremap = true, silent = true })

-- Competitivetest
-- 设置快捷键用于常见的 CompetitiveTest 操作
vim.api.nvim_set_keymap('n', 'ca', ':CompetiTest add_testcase<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'cr', ':CompetiTest run<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ce', ':CompetiTest edit_testcase<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ct', ':CompetiTest receive testcases<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'cp', ':CompetiTest receive problem<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'cc', ':CompetiTest receive contest<CR>', { noremap = true, silent = true })

-- 设置快捷键为 <Leader>cd，用于更改当前工作目录为文件所在目录
vim.api.nvim_set_keymap('n', '<Leader>cd', ':lua ChangeDirectoryToCurrentFile()<CR>', { noremap = true, silent = true })

-- 定义函数 ChangeDirectoryToCurrentFile
function ChangeDirectoryToCurrentFile()
    local current_file_path = vim.fn.expand('%:p:h')
    vim.cmd('cd ' .. current_file_path)
    vim.notify('Current directory changed to: ' .. current_file_path, vim.log.levels.INFO)
end

-- 使用 Telescope 打开文件浏览器
vim.api.nvim_set_keymap('n', '<Leader>fb', ":Telescope file_browser<CR>", { noremap = true, silent = true })

-- 字体大小调整
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

-- 绑定快捷键用于增减字体大小
vim.api.nvim_set_keymap("n", "<C-+>", ":lua increase_font_size()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-=>", ":lua increase_font_size()<CR>", { noremap = true, silent = true }) -- 处理键盘布局不同情况
vim.api.nvim_set_keymap("n", "<C-->", ":lua decrease_font_size()<CR>", { noremap = true, silent = true })

-- 设置初始字体大小
set_font_size(default_font_size)
