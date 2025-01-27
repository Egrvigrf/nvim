## 前言
&emsp;&emsp;为什么这么多IDE不用要整个neovim，还得从头开始自己配？就是能对自己的编码环境的各种细节有所掌控，高度自定化。  
&emsp;&emsp;大一上国庆的时候整了个ubuntu和neovim玩，后来觉得太麻烦放弃了。  
2024/5/1假期刷算法之余整个neovim的配置玩玩，就当作放松了（其实有时候整得挺崩溃的），刚好之前用学了用vscode的源代码管理(git)同步笔记，一键push到github也方便很多。就把之前的配置代码pull下来改改，不过就不在linux上了，平时cf打比赛还是vscode方便。  
2024/5/13 不搞了，太难了,一直检测不到c++ stl.  
## nvimconfig
- 使用lazy插件管理器
- mason来代码补全

## 可能出现的问题
- lualine的符号显示乱码，需要设置支持图形字符的终端字体（比如Nerd fonts）  
  
windows 默认配置文件位置%AppDate%/local/nvim  
启动nvim时先执行init.lua文件  

插件管理器:Lazy

# 7-10
配置快捷键在windows命令，编译和运行F5  
解决lsp报错的问题  
在C:\Users\bairong\AppData\Local\clangd目录下建立新建一个config.yaml文件  
配置如下  
CompileFlags:  
  Add:
    - --target=x86_64-w64-windows-gnu

# 7-11 到 7-13
借助chatgpt，完善功能，现在的nvim配置写算竞代码体验已经接近vscode  

# 7-13
使用clang-format 格式化代码
用mason-tool由于网络原因没法安装llvm，手动安装llvm（含有clang-format）  
把/bin添加到环境变量后  
[llvm](https://github.com/llvm/llvm-project/releases/)  
然后在conform自动补全插件里设置  

很神奇，直接用:MasonInstall clang-format就成功了，自动安装反而安不上  

mark a  标记名为a
:marks 查看所有标签
:delmarks a-zA-Z0-9!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~

# 2024 10-29
早就已经把nvim抛弃了，扔到这个仓库下面来吃灰了，不知道哪天会重新开始玩。  
cphelper的地位不可撼动。
