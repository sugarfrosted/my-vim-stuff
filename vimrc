syntax on
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

autocmd BufRead,BufNewFile *.tikz set filetype=tex

autocmd BufRead,BufNewFile *.mac set filetype=maxima
autocmd BufRead,BufNewFile *.mac set number

"bibtex files
autocmd BufRead,BufNewFile *.bib set tabstop=2
autocmd BufRead,BufNewFile *.bib set shiftwidth=2
autocmd BufRead,BufNewFile *.bib set foldmethod=indent
autocmd BufRead,BufNewFile *.bib set foldcolumn=1

autocmd BufRead,BufNewFile *.bibtex set filetype=bib
autocmd BufRead,BufNewFile *.bibtex set tabstop=2
autocmd BufRead,BufNewFile *.bibtex set shiftwidth=2
autocmd BufRead,BufNewFile *.bibtex set foldmethod=indent
autocmd BufRead,BufNewFile *.bibtex set foldcolumn=1

autocmd BufRead,BufNewFile *.tex set foldcolumn=6
autocmd BufRead,BufNewFile *.tex set linebreak
"autocmd BufRead,BufNewFile *.tex set wrapmargin=7
autocmd BufRead,BufNewFile *.tex set spell
autocmd BufRead,BufNewFile *.tex set breakindent showbreak=\ \ 
autocmd BufRead,BufNewFile *.tex map t :Yidkey<Enter>
autocmd BufRead,BufNewFile *.tex map T :Yidkey<Enter>
autocmd BufRead,BufNewFile *.tex vmap <F9> :w !detex \| wc -w<enter>
autocmd BufRead,BufNewFile *.tex vmap \\wc :w !detex \| wc -w<enter>
autocmd BufRead,BufNewFile *.tex vmap \\WC :w !detex \| wc -w<enter>
autocmd BufRead,BufNewFile *.tex imap <F8> :Yidkey<Enter>



map אַ a
map א A
map ג g
map י i
map יִ I
map אָ o
map _ O
map ו u
map וּ U
map ס s
map ת S
map כ x
map ט :set rightleft<Enter>
map ֦  D
map ד d
map ר r
map װ v
"map V V
map ׃ :
map ׃ש :w
map ז z
map ייִ :set spelllang=yi<Enter>
map yi :set spelllang=yi<Enter>
map en :set spelllang=en_us<Enter>


" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

let g:yidl=0
let g:testvar=0


function! InitYidl()
    let g:testvar=1
    if !exists("w:yidl")
        let w:yidl=0
    endif
endfunction

"autocmd WinEnter :call InitYidl()

let g:precomposed=1
function! Composure()
    if g:precomposed
        let g:precomposed=0
        if &keymap=="yiddishprecomp_utf-8"
            set keymap=yiddishpn_utf-8
            echo "Not Precomposed"
        endif
    else
        let g:precomposed=1
        if &keymap=="yiddishpn_utf-8"
            set keymap=yiddishprecomp_utf-8
            echo "Precomposed"
        endif
    endif
endfunction

function! YiddishKeyBoard()
    if g:yidl
        set spelllang=en_us
        set norightleft
        set keymap=""
        set norevins
        let g:yidl=0
        echo "English"
        unmap \|
    else
        if g:precomposed
            set keymap=yiddishprecomp_utf-8
            set spelllang=yi-pc
            echo "Precomposed Yiddish"
        else
            set keymap=yiddishpn_utf-8 
            set spelllang=yi
            echo "Non-Precomposed Yiddish"
        endif
        if !&termbidi
            set rightleft
        endif
        let g:yidl=1
        map \| :Precomp<Enter>
    endif
endfunction


command Yidkey :call YiddishKeyBoard()
command Precomp :call Composure()
