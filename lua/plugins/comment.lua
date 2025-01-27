return {
      
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        padding = true,  -- 行注释和代码之间加空格
        toggler = {
          line = 'gcc',  -- 行注释的快捷键
          block = 'gbc', -- 块注释的快捷键
        },
        opleader = {
          line = 'gc',   -- 行注释操作符的快捷键
          block = 'gb',  -- 块注释操作符的快捷键
        },
        extra = {
          above = 'gcO', -- 在上一行插入注释
          below = 'gco', -- 在下一行插入注释
          eol = 'gcA',   -- 在行尾插入注释
        },
        mappings = {
          basic = true,  -- 启用基本注释映射
          extra = true,  -- 启用额外的注释映射
        },
        ft = {
          cpp = {
            line = '//%s',  -- C++ 行注释的格式
            block = '/*%s*/', -- C++ 块注释的格式
          },
        },
      })
    end,
  
}