# Rainbow Parentheses Improved
这是一份[Rainbow Parentheses Improved](http://www.vim.org/scripts/script.php?script_id=4176)(作者[luo chen](http://www.vim.org/account/profile.php?user_id=53618)) 的克隆个性化版本 

## 改进
* 任何大括号外的运算符都会获得彩虹的最后一种颜色。以前，它被忽略以突出显示。

* 简化/更正了逻辑，将大括号的突出显示优先级定义为高于运算符的优先级。因此，如果你有一个大括号，它也是一个运算符，并且你遇到了它可以匹配两个角色的情况，它将承担大括号角色。

* 更改了默认突出显示的运算符（现在大多数标点符号）和突出显示的大括号（为 C++、Rust、C# 和 Java 添加了 `<`和`>`括号）

* 删除了运算符的可选高亮显示。现在硬启用。

* 更改了事件“语法”和“配色方案”的加载自动命令，以便仅在应用语法时加载彩虹，并在切换配色方案后消失。

* 更改了默认颜色。从[gruvbox colorscheme](https://github.com/morhetz/gruvbox/blob/master/colors/gruvbox.vim#L366)配色方案复制的默认彩虹色（适用于深色和浅色背景）。 

Chevrons 是一个很难处理的案例。为了区分“小于”和“开放泛型参数列表的括号”，假设“小于”将始终被空格包围。如果没有，它将被视为打开模板的尖括号（尽管仍然对 `template` 或 `operator` 关键字进行一些检查，例如 C++）。

# 安装

```vim
Plugin 'IammyselfYBX/vim-rainbow'
```

# 简单配置
在 `.vimrc`中添加

```vim
" 在 c,C++, objc中加载 rainbow
au FileType c,cpp,objc,objcpp call rainbow#load()
```
或者只是这样才能全局启用它：

```vim
let g:rainbow_active = 1
```

# 高级设置

高级配置允许您定义要用于每种类型的文件的括号。您还可以通过这种方式确定括号的颜色（读取所有命名颜色的文件 vim73/rgb.txt）。

```vim
let g:rainbow_active = 1

let g:rainbow_load_separately = [
    \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
    \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
    \ ]

let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']
```

# 用户命令
```
:RainbowToggle  --打开/关闭 Rainbow 插件
:RainbowLoad    --加载/重新加载 Rainbow 插件
```
