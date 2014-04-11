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
"key paging remaps
autocmd BufRead,BufNewFile *.tex nnoremap j gj
autocmd BufRead,BufNewFile *.tex nnoremap k gk
autocmd BufRead,BufNewFile *.tex nnoremap gj j
autocmd BufRead,BufNewFile *.tex nnoremap gk k
autocmd BufRead,BufNewFile *.tex nnoremap <down> gj
autocmd BufRead,BufNewFile *.tex nnoremap <up> gk

autocmd BufRead,BufNewFile *.tex command Parag :call ParagraphPaging()


function! ParagraphPaging() "swaps row and line changing keys.
    if !exists("g:paragraphMode")
        let g:paragraphMode=0
    endif
    if g:paragraphMode==0
        let g:paragraphMode=1
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
    if !exists("w:yidl") "sets default value for w:yidl if not yet set
        let w:yidl=0 "assumed initial value
    endif
    if w:yidl "turns off yiddish mode and switches back to english
        set spelllang=en_us
        set norightleft
        set keymap=""
        set norevins
        let w:yidl = 0
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
        if &termbidi
            nnoremap h l
            nnoremap l h
        else
            set rightleft
        endif
        let w:yidl=1
        map \| :Precomp<Enter>
    endif
endfunction

function! YiddishComposingTranslation()
    if !exists("w:yidl")
        let w:yidl=0
    endif
    if w:yidl
        if g:precomposed
            let g:directionlist=["Non-Precomposed Yiddish","Precomposed Yiddish"]
        else 
            let g:directionlist=["Precomposed Yiddish","Non-Precomposed Yiddish"]
        endif
        if &modified
            echo "File has been modified"
        else
            let w:butt=0
            while w:butt==0
                call inputsave()
                let w:butt=confirm("Would you like to translate " . @% . " from " . g:directionlist[0] . " to " . g:directionlist[1] . "?", "&Yes\n&no")
                call inputrestore()
            endwhile
            if w:butt==1
                if g:precomposed
                    execute "!" . "python $HOME/.vim/pythonscripts/composing.py " . @% . ">" . @% . ".tmp; cp " . @% . ".tmp " . @%
                else
                    execute "!" . "python $HOME/.vim/pythonscripts/decomposing.py " . @% . ">" . @% . ".tmp; cp " . @% . ".tmp " . @%
                endif
            endif
        endif
    endif
endfunction


command Yidkey :call YiddishKeyBoard()
command Precomp :call Composure()
