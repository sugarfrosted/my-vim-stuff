command WQCRON :call WQCRON()
function WQCRON()
    set compatible
    wq
endfunction



"python from sys import path ; path+=["~/.vim/bundle/ultisnips/pythonx"]
    let g:LatexBox_Folding=1       " - Turn on/off folding
    let g:LatexBox_fold_preamble=1 " - Turn on/off folding of preamble
    "let g:LatexBox_fold_parts = [   " - Define parts (eq. appendix, frontmatter) to fold
    let g:LatexBox_fold_sections = [
        \ "part",
        \ "chapter",
        \ "section",
        \ "subsection",
        \ "subsubsection"
        \ ] " - Define section levels to fold
    let g:LatexBox_fold_envs=1     " - Turn on/off folding of environments
syntax on

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<s-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


function! FoldLetter(num)
    let g:LatexBox_Folding=a:num
    if a:num == 0
        noremap <c-q> :call FoldLetter(1)
    else
        unmap <c-q>
endfunction

python << endpython
from unicodedata import normalize
import vim
import os
import subprocess
import datetime
import time

def regexthing(decomposables = "URABIGDUMMY"):
    if decomposables == "URABIGDUMMY":
        chars = vim.current.window.buffer.vars["decompchars"]
    if vim.buffer.vars["precomposed"]:
        for char in chars.decode('utf-8'):
            vim.command("'<,'>s/"+normalize('NKD',char)+"/"+char+"/g")        
            print "Characters now precomposed"
    else:
        for char in chars.decode('utf-8'):
            vim.command("'<,'>s/"+char+"/"+normalize('NKD',char)+"/g")        
            print "Characters now decomposed"

def updated(string):
    return string != 'Already up-to-date.'
def updateBundle():
    home = os.path.expanduser("~")
    path = os.path.join(home, ".vim", "bundle")
    dirs = os.listdir( path )
    cmd  = ["git", "pull"]
    #vim.command("new")
    outwindow = vim.current.window.buffer
    outwindow[0] = str(datetime.datetime.today()) + "\n"

    Print_Restart = False
    for f in dirs:
        if os.path.isdir(os.path.join(path, f )):
            if os.path.isdir(os.path.join(path, f, '.git')):
                os.chdir(os.path.join(path, f ))
                outwindow.append([os.path.join(path, f )])
                subprocesshold = subprocess.check_output(cmd)
                if not Print_Restart and updated(subprocesshold[0]):
                    Print_Restart = True
                outwindow.append(subprocesshold)
    if Print_Restart:
        outwindow.append("Restart Vim to have take effect.",1)
    vim.command("set readonly nomodified")
endpython
command UpdateBundle call UpdateBundle()
command BundleUpdate call UpdateBundle()
function UpdateBundle()
    new
    python updateBundle()
endfunction


set t_Co=256
colorscheme distinguished
let g:tex_indent_items = 1
set spelllang=en_us
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set encoding=utf-8
set maxcombine=3
execute pathogen#infect()
set runtimepath^=~/.vim/bundle/ctrlp.vim
set showcmd
" Enable use of the mouse for all modes
set mouse=a

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>
set pastetoggle=<c_Leader>p

autocmd BufRead,BufNewFile * let w:decompchars=""

autocmd BufRead,BufNewFile *.tikz call TexSetup()

autocmd BufRead,BufNewFile *.mac call MaximaSetup()


let g:signify_exceptions_filetype = [ 'maxima' ]
"bibtex files

autocmd BufRead,BufNewFile *.bib call BibSetup()

autocmd BufRead,BufNewFile *.bibtex call BibSetup()

autocmd BufRead,BufNewFile *.tex call TexSetup()

autocmd BufRead,BufNewFile *.xe.tex call XeTexSetup()

autocmd BufRead,BufNewFile *.py call PythonSetup()

autocmd WinLeave * call CombDoodle() 
                        
function! CombDoodle()
    if exists("w:precomposed")
        let g:precomposed = w:precomposed
    endif
endfunction

function! MaximaSetup()
    set filetype=maxima
    set number
    RltvNmbr
    let g:signify_mapping_toggle = '<leader>sg'
endfunction

function! TexSetup()
    set filetype=tex
    if !exists(":Parag")
        command Parag :call ParagraphPaging()
    endif
    set foldcolumn=6
    set linebreak
"    set wrapmargin=7
    set spell
    set breakindent showbreak=..
    noremap t :Yidkey<Enter>
    noremap T :Yidkey<Enter>
    vnoremap <F9> :w !detex \| wc -w<enter>
    noremap <Leader>tran :call YiddishComposingTranslation()<Enter>
    vnoremap <Leader>wc :w !detex \| wc -w<enter>
    vnoremap <Leader>c :'<,'>s/^/%/g
    noremap <Leader>c :.s/^/%/g
    inoremap <F8> :Yidkey<Enter>
"key paging remaps
"    nnoremap j gj
"    nnoremap k gk
"    nnoremap gj j
"    nnoremap gk k
"    nnoremap <down> gj
"    nnoremap <up> gk
    nnoremap ∆ gj
    nnoremap ˚ gk
    nnoremap ¢ g$
    nnoremap º g0
    nnoremap § g^
    set relativenumber
    set foldmethod=expr
    if !exists("g:LatexBox_Folding")
        let g:LatexBox_Folding=0       " - Turn on/off folding
    endif
    if !exists("g:LatexBox_fold_preamble")
        let g:LatexBox_fold_preamble=1 " - Turn on/off folding of preamble
    endif
    if !exists("g:LatexBox_fold_parts")
        "let g:LatexBox_fold_parts = [   " - Define parts (eq. appendix, frontmatter) to fold
    endif
    if !exists("g:LatexBox_fold_sections")
        let g:LatexBox_fold_sections = [
            \ "part",
            \ "chapter",
            \ "section",
            \ "subsection",
            \ "subsubsection"
            \ ] " - Define section levels to fold
    endif
    if !exists("g:LatexBox_fold_envs")
        let g:LatexBox_fold_envs=1     " - Turn on/off folding of environments
    endif
    "py import datetime
    "w:ydm = py print
    "            \[datetime.date.today().year,
    "            \ datetime.date.today().day,
    "            \ datetime.date.today().month,
    "            \]
    command XeL :call XeLaTeXmk()<Return>
    command XeLaTex :call XeLaTeXmk()<Return>
    let w:precomposed=g:precomposed
endfunction

function! XeTexSetup()
    call XeLaTeXmk()
endfunction

function! BibSetup()
    set filetype=bib
    set tabstop=2
    set shiftwidth=2
    set foldmethod=indent
    set foldcolumn=1
endfunction


function! PythonSetup()
    set filetype=python
    set relativenumber
endfunction

let g:paragraphMode=0
function! ParagraphPaging() "swaps row and line changing keys.
    if !exists("w:paragraphMode")
        let w:paragraphMode = g:paragraphMode
    endif
    if w:paragraphMode==0
        let w:paragraphMode=1
        unmap k
        unmap j
        unmap gj
        unmap gk
        unmap <down>
        unmap <up>
        echo "Paragraph Paging"
    else
        nnoremap j gj
        nnoremap k gk
        nnoremap gk k
        nnoremap gj j
        nnoremap <down> gj
        nnoremap <up> gk
        echo "Line Paging"
    endif
endfunction

function XeLaTeXmk() 
    if !exists("g:XeLaTeXmk") || !g:XeLaTeXmk
        g:XeLaTeXmk = 1
        g:LatexBox_latexmk_options .= " -xelatex"
    endif
endfunction


" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
"set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
"set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
"let g:tex_flavor='latex'

let g:precomposed=1
function! Composure()
    if g:precomposed
        let g:precomposed=0
        iabbrev כּ כּ
        iabbrev ײַ ײַ
        iabbrev אָ אָ
        iabbrev אַ אַ
        iabbrev פּ פּ
        iabbrev פֿ פֿ
        iabbrev שׂ שׂ
        iabbrev וּ וּ
        iabbrev יִ יִ
        iabbrev תּ תּ
        iabbrev בֿ בֿ
        echo "Not Precomposed"
    else
        let g:precomposed=1
        iunabbrev כּ
        iunabbrev ײַ
        iunabbrev אָ
        iunabbrev אַ
        iunabbrev פּ
        iunabbrev פֿ
        iunabbrev שׂ
        iunabbrev וּ
        iunabbrev יִ
        iunabbrev תּ
        iunabbrev בֿ
        echo "Precomposed"
    endif
endfunction

function! YiddishKeyBoard()
    if !exists("w:yidl") "sets default value for w:yidl if not yet set
        let w:yidl=0 "assumed initial value
    endif
    if w:yidl "turns off yiddish mode and switches back to english
        set spelllang=en_us
        set norightleft
        set keymap=""
        set norevins
        let w:decompchars=""
        let w:yidl = 0
        echo "English"
        unmap \|
    else
        set keymap=yiddishprecomp_utf-8
        let w:decompchars="אַאָכּפּפֿבֿתּיִוּײַשׂ"
        if g:precomposed
            set spelllang=yi-pc
            echo "Precomposed Yiddish"
        else
            set spelllang=yi
            echo "Non-Precomposed Yiddish"
        endif
        if &termbidi
            nnoremap h l
            nnoremap l h
        else
            set rightleft
        endif
        let w:yidl=1
        noremap \| :Precomp<Enter>
    endif
endfunction



command Yidkey :call YiddishKeyBoard()
command Precomp :call Composure()
command CompTrans :call YiddishComposingTranslation()
