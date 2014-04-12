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

" Enable use of the mouse for all modes
set mouse=a

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>


autocmd BufRead,BufNewFile *.tikz set call TexSetup()

autocmd BufRead,BufNewFile *.mac set filetype=maxima
autocmd BufRead,BufNewFile *.mac set number
autocmd BufRead,BufNewFile *.mac RltvNmbr


"bibtex files

autocmd BufRead,BufNewFile *.bib call BibSetup()

autocmd BufRead,BufNewFile *.bibtex call BibSetup()

autocmd BufRead,BufNewFile *.tex call TexSetup()

autocmd BufRead,BufNewFile *.py call PythonSetup()

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
    map t :Yidkey<Enter>
    map T :Yidkey<Enter>
    vmap <F9> :w !detex \| wc -w<enter>
    map \c :call YiddishComposingTranslation()<Enter>
    vmap \wc :w !detex \| wc -w<enter>
    imap <F8> :Yidkey<Enter>
"key paging remaps
    nnoremap j gj
    nnoremap k gk
    nnoremap gj j
    nnoremap gk k
    nnoremap <down> gj
    nnoremap <up> gk
    set relativenumber
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
            let w:anyway=0
            while w:anyway==0
                call inputsave() 
                let w:anyway=confirm("File ``" . @% . "'' modified. Would you like to continue anyway?","&Yes\n&no")
                call inputrestore()
            endwhile
            if w:anyway==2
                 return 0
            endif
        endif
        let w:butt=0
        while w:butt==0
            call inputsave()
            let w:butt=confirm("Would you like to translate " . @% . " from " . g:directionlist[0] . " to " . g:directionlist[1] . "?", "&Yes\n&no")
            call inputrestore()
        endwhile
        if w:butt==1
            let w:autoreadstatus=&autoread
            set autoread
            execute "!" . "python $HOME/.vim/pythonscripts/composing.py " . @% . " " . g:precomposed ">" . @% . ".tmp; cp " . @% . ".tmp " . @%
            let &autoread=w:autoreadstatus
        endif
    else
        echo "File not in Yiddish"
    endif
endfunction


command Yidkey :call YiddishKeyBoard()
command Precomp :call Composure()
command CompTrans :call YiddishComposingTranslation()
