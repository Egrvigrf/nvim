local k = vim.keymap
vim.g.mapleader = " "

-- Normal mode
-- Clear search highlights
k.set("n", "<leader>nh", ":nohl<CR>")

function CompileAndRun()
    vim.cmd("write")  -- 保存文件

    -- 获取当前文件的完整路径（带扩展名）
    local filepath = vim.fn.expand('%:p')  
    -- 获取当前文件的文件名（不带扩展名）作为输出文件名
    local output_name = vim.fn.expand('%:t:r')  -- 当前文件名（不带扩展名）

    -- 判断当前操作系统
    if vim.fn.has("unix") == 1 then
        -- Linux 或其他 Unix 系统
        local file_path = vim.fn.expand('%:p')
        local output_name = vim.fn.expand('%:p:r')
    
        -- 更改当前工作目录为文件所在目录
        vim.cmd("lcd " .. vim.fn.expand('%:p:h'))
    
        -- 构建编译命令
        local compile_cmd = string.format("g++ -std=c++20 \"%s\" -o \"%s\"", file_path, output_name)
        -- 构建运行命令
        local run_cmd = string.format("./%s", output_name:match("([^/]+)$"))
    
        -- 尝试编译并运行
        if vim.fn.system(compile_cmd) == "" then
            vim.cmd(string.format("vsplit | term bash -c \"%s\"", run_cmd))
        end
    elseif vim.fn.has("win32") == 1 then
        -- Windows 系统
        vim.cmd(string.format(
            "vsplit | term g++ \"%s\" -o \"%s\" && \"%s\"",
            filepath,  -- 源文件
            output_name,  -- 输出文件
            output_name  -- 运行输出文件
        ))
    end

    -- 打开终端后自动进入插入模式
    vim.cmd("startinsert")
end

vim.api.nvim_set_keymap('n', '<F5>', ':lua CompileAndRun()<CR>', { noremap = true, silent = true })

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


-- 使用 ctrl+A 复制所有到剪贴板
vim.api.nvim_set_keymap('n', '<C-Y>', 'ggVG"+y', { noremap = true })
-- 将 Ctrl + V 映射为粘贴剪贴板内容
vim.keymap.set('n', '<C-v>', '"+p', { noremap = true, silent = true })

-- 将 Ctrl + C 映射为复制当前选中的内容到剪贴板
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true })

