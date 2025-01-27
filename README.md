
## nvimconfig
- 使用lazy插件管理器
- mason来管理代码补全
## 可能出现的问题
- lualine和telescope的符号显示乱码，需要设置支持图形字符的终端字体（比如Nerd fonts）  
  
windows 默认配置文件位置$LOCALAPPDATA\nvim  
启动nvim时先执行init.lua文件  

解决windows下lsp clangd报错检测不到c++头文件的问题  
在$LOCALAPPDATA\clangd目录下建立新建一个config.yaml文件  
配置如下  
```
CompileFlags:  
  Add:
    - --target=x86_64-w64-windows-gnu
```
[参考Github讨论](https://github.com/clangd/clangd/issues/537#issuecomment-1479544442)  

## 
使用clang-format 格式化代码
用mason-tool由于网络原因没法安装llvm，手动安装llvm（含有clang-format）  
把/bin添加到环境变量后  
[llvm](https://github.com/llvm/llvm-project/releases/)  
然后在conform自动补全插件里设置  

安装失败可以尝试直接用:MasonInstall clang-format --force  
:MasonInstall clangd --force  

mark a  标记名为a
:marks 查看所有标签
:delmarks a-zA-Z0-9!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~

