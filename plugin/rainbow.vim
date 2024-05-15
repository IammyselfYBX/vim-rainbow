"==============================================================================
"Script Title: rainbow parentheses improved
"              rainbow 括号改进
"Script Version: 0.01
"Author: 贾继伟
"Last Edited: 1999/09/23

" 默认使用从gruvbox配色方案复制的彩虹色（https://github.com/morhetz/gruvbox）。
" 这些颜色通常适用于浅色和深色的配色方案。
let s:guifgs = exists('g:rainbow_guifgs')? g:rainbow_guifgs : [
            \ '#458588', " 深蓝绿色
            \ '#b16286', " 浅红色
            \ '#cc241d', " 深红色
            \ '#d65d0e', " 橙色
            \ '#458588', " 重复的颜色，以此类推
            \ '#b16286',
            \ '#cc241d',
            \ '#d65d0e',
            \ '#458588',
            \ '#b16286',
            \ '#cc241d',
            \ '#d65d0e',
            \ '#458588',
            \ '#b16286',
            \ '#cc241d',
            \ '#d65d0e',
            \ ]

" 控制台颜色设置，用于不支持 GUI 的环境。
let s:ctermfgs = exists('g:rainbow_ctermfgs')? g:rainbow_ctermfgs : [
            \ 'brown',        " 棕色
            \ 'Darkblue',     " 深蓝色
            \ 'darkgray',     " 深灰色
            \ 'darkgreen',    " 深绿色
            \ 'darkcyan',     " 深青色
            \ 'darkred',      " 深红色
            \ 'darkmagenta',  " 深洋红色
            \ 'brown',        " 重复的颜色，以此类推
            \ 'gray',
            \ 'black',
            \ 'darkmagenta',
            \ 'Darkblue',
            \ 'darkgreen',
            \ 'darkcyan',
            \ 'darkred',
            \ 'red',
            \ ]

" 设置最大层数，取决于是否运行在 GUI 下。
let s:max = has('gui_running')? len(s:guifgs) : len(s:ctermfgs)

" 主函数，用于加载或重新加载彩虹括号功能。
func! rainbow#load(...)
    " 检查是否已加载，若是则清除现有设置。
    if exists('b:loaded')
        cal rainbow#clear()
    endif

    " 根据文件类型定义不同的括号集合。
    if a:0 >= 1
        let b:loaded = a:1
    elseif &ft == 'cpp'
        let b:loaded = [
                    \ ['(', ')'],
                    \ ['\[', '\]'],
                    \ ['{', '}'],
                    \ ['\v%(<operator\_s*)@<!%(%(\i|^\_s*|template\_s*)@<=\<[<#=]@!|\<@<!\<[[:space:]<#=]@!)', '\v%(-)@<!\>']
                    \ ]
    elseif &ft == 'rust' || &ft == 'cs' || &ft == 'java'
        let b:loaded = [
                    \ ['(', ')'],
                    \ ['\[', '\]'],
                    \ ['{', '}'],
                    \ ['\v%(\i|^\_s*)@<=\<[<#=]@!|\<@<!\<[[:space:]<#=]@!', '\v%(-)@<!\>']
                    \ ]
    else
        let b:loaded = [ ['(', ')'], ['\[', '\]'], ['{', '}'] ]
    endif

    " 设置操作符匹配模式。
    let b:operators = (a:0 < 2) ? '"\v[{\[(<_"''`#*/>)\]}]@![[:punct:]]|\*/@!|/[/*]@!|\<#@!|#@<!\>"' : a:2

    if b:operators != ''
        exe 'syn match op_lv0 '.b:operators
        let cmd = 'syn match %s %s containedin=%s contained'
        for [left , right] in b:loaded
            for each in range(1, s:max)
                exe printf(cmd, 'op_lv'.each, b:operators, 'lv'.each)
            endfor
        endfor
    endif

    let str = 'TOP'
    for each in range(1, s:max)
        let str .= ',lv'.each
    endfor

    let cmd = 'syn region %s matchgroup=%s start=+%s+ end=+%s+ containedin=%s contains=%s,%s,@Spell fold'
    for [left , right] in b:loaded
        for each in range(1, s:max)
            exe printf(cmd, 'lv'.each, 'lv'.each.'c', left, right, 'lv'.(each % s:max + 1), str, 'op_lv'.each)
        endfor
    endfor

    cal rainbow#activate()
endfunc

" 清除彩虹括号的函数。
func! rainbow#clear()
    " 清除所有彩虹括号相关的语法和高亮设置。
    if exists('b:loaded')
        unlet b:loaded
        exe 'syn clear op_lv0'
        for each in range(1 , s:max)
            exe 'syn clear lv'.each
            exe 'syn clear op_lv'.each
        endfor
    endif
endfunc

" 激活rainbow函数
func! rainbow#activate()
    if !exists('b:loaded')
        cal rainbow#load()
    endif
    exe 'hi default op_lv0 ctermfg='.s:ctermfgs[-1].' guifg='.s:guifgs[-1]
    for id in range(1 , s:max)
        let ctermfg = s:ctermfgs[(s:max - id) % len(s:ctermfgs)]
        let guifg = s:guifgs[(s:max - id) % len(s:guifgs)]
        exe 'hi default lv'.id.'c ctermfg='.ctermfg.' guifg='.guifg
        exe 'hi default op_lv'.id.' ctermfg='.ctermfg.' guifg='.guifg
    endfor
    exe 'syn sync fromstart'
    let b:active = 'active'
endfunc

" 关闭rainbow函数
func! rainbow#inactivate()
    if exists('b:active')
        exe 'hi clear op_lv0'
        for each in range(1, s:max)
            exe 'hi clear lv'.each.'c'
            exe 'hi clear op_lv'.each.''
        endfor
        exe 'syn sync fromstart'
        unlet b:active
    endif
endfunc

" rainbow开关
func! rainbow#toggle()
    if exists('b:active')
        cal rainbow#inactivate()
    else
        cal rainbow#activate()
    endif
endfunc

if exists('g:rainbow_active') && g:rainbow_active
    if exists('g:rainbow_load_separately')
        let ps = g:rainbow_load_separately
        for i in range(len(ps))
            if len(ps[i]) < 3
                exe printf('au syntax,colorscheme %s call rainbow#load(ps[%d][1])' , ps[i][0] , i)
            else
                exe printf('au syntax,colorscheme %s call rainbow#load(ps[%d][1] , ps[%d][2])' , ps[i][0] , i , i)
            endif
        endfor
    else
        au syntax,colorscheme * call rainbow#load()
    endif
endif

" 定义插件命令，以便用户可以手动加载或清除彩虹括号。
command! RainbowToggle call rainbow#toggle()
command! RainbowLoad call rainbow#load()
