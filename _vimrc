"/******************************************************************************
" * System
" ******************************************************************************/

"/* Source the system _vimrc (which also loads vimrc_example.vim) */
source $VIM/_vimrc

"/******************************************************************************
" * Override any $VIM/_vimrc settings
" */

"/* Reset textwidth */
au! vimrcEx FileType text setlocal tw&

"/* http://superuser.com/questions/697847/cant-run-vimdiff-7-4-on-windows-7 */
set diffexpr=MyDiff_Fix_Vim74_E97_QuoteBug()

"/******************************************************************************
" * Other settings
" */

"let profile_dir = $HOME/vim
"let profile_dir = $VIM . "/profiles/lem/vim"
"
"source $VIM/profiles/lem/colors/gray_on_black.vim
"exec "source " . profile_dir . "/colors/gray_on_black.vim"
"
"let STL = "%<%f%m%r%(\ (type:%Y)%)%(\ %a%)\ %h%w%q%=%-30.(%l(%p%%)/%L,%c%V%)\ %P"
"let STL = "%<%f%m%r%(\\ (type:%Y)%)%(\\ %a%)\\ %h%w%q%=%-30.(%l(%p%%)/%L,%c%V%)\\ %P"

"/* See $VIMRUNTIME\doc\usr_21.txt: *21.3*  Remembering information; viminfo
" * Also see ":help viminfo"
" * Default is '100,<50,s10,h,rA:,rB: */
"set viminfo+=f1
set viminfo+=c

"/******************************************************************************
" * Options                                                                   
" * (See ":options" for interactive settings and ":help options" for details) 
" ******************************************************************************/

set nobk wb nows
set ts=4 sw=4 tw=0 shm=at go-=T 
set viewdir=$HOME/vimfiles/views
set sessionoptions+=unix,slash,resize
set listchars+=tab:>-,trail:-

"/* 
" * Status line
" */

"set statusline=%<%f%m%r%(\ (type:%Y)%)%(\ %a%)\ %h%w%q%=%-30.(%l(%p%%)/%L,%c%V%)\ %P
"set statusline=%<%f%m%r%(\ (%Y)%)%(\ %a%)\ %h%w%q%=%-30.(%l(%p%%)/%L,%c%V%)\ %P
"set statusline=%<%f\ %m%r%=%-30(%(\ (%Y)%)%(%a%)\ %h%w%q%)\ %5(<%n>%)\ %-30.(%l(%p%%)/%L,%c%V%)\ %P
"set statusline=%<%f\ %m%r%=%-30(%(\ (%Y)%)%(%a%)\ %h%w%q%)\ %5(<%n>%)\ %-30.(%l/%L(%p%%),%c%V%)\ %P
set statusline=%<%f\ %m%r%=%-30(%(\ (%Y)%)%(%a%)\ %h%w%q%)\ %5(<%n>%)\ %-30.(%l/%L(%p%%),%c%V%)\ #%{winnr()}\ %P
set rulerformat=%60(%m%r%(\ (%Y)%)%(%a%)%(\ %h%w%q%)\ %=<%n>\ %-30.(%l/%L(%p%%),%c%V%)\ #%{winnr()}\ %P%)
"exec "set statusline=".STL
"exec "set rulerformat=".STL
"set rulerformat=%<%f%m%r%(\ (type:%Y)%)%(\ %a%)\ %h%w%q%=%-30.(%l(%p%%)/%L,%c%V%)\ %P

"/******************************************************************************
" * Colors
" ******************************************************************************/

"colo darkblue_lem
"runtime colors/darkblue_lem.vim

"/******************************************************************************
" * Fonts
" ******************************************************************************/

"/* Like Notepad */
if has('gui_running')
  set guifont=Lucida_Console:h10:cANSI
endif

"/******************************************************************************
" * Mappings
" ******************************************************************************/

"/*
" * Remove
" */

"/* (Q was mapped to 'gq' operator in pre-vim 5.0. Remove to default to Ex mode)
unmap Q

"/* Unmap some unwanted/redundant mswin.vim bindings (undo, redo, select all, etc) */
unmap <C-Y>
iunmap <C-Y>
iunmap <C-A>
"unmap <C-Z>

"/*
" * Scrolling
" */

"/* Full page scrolling */
map <PageUp> :call ScrollFullWindow("up")<CR>
map <PageDown> :call ScrollFullWindow("down")<CR>
imap <PageUp> <C-O>:call ScrollFullWindow("up")<CR>
imap <PageDown> <C-O>:call ScrollFullWindow("down")<CR>

"/* Move within lines */
map <Up> gk
map <Down> gj
map <Home> :call MoveWithinLine("0")<CR>
map <End> :call MoveWithinLine("$")<CR>
imap <Up> <C-O>:exe "normal! gk"<CR>
imap <Down> <C-O>:exe "normal! gj"<CR>
imap <Home> <C-O>:call MoveWithinLine("0")<CR>
imap <End> <C-O>:call MoveWithinLine("$")<CR>

"/*
" * Alternative defaults
" */

"/* increment/decrement numbers */
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>

"/*
" * Custom
" */

"/* Section breaks */
imap <F5> <C-R>=NotepadF5()<C-M>
imap <F6> <ESC>79i=<ESC>o
imap <S-F5> <F6><ESC>o<F5><CR><CR>

"/* Window navigation */
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

"/******************************************************************************
" * Functions
" ******************************************************************************/

function! MoveWithinLine(direction)
    let move = "norm! "
    if &wrap == 1
        let move = move . "g"
    endif
    exe move . a:direction
endfunction

function! ScrollFullWindow(direction)
    let jumpTo = "keepj normal! "
    if (a:direction ==? "up")
        let nextLine = line("w0") - 1
        if nextLine > 0
            exe jumpTo . nextLine . "Gzb"
        endif
    elseif (a:direction ==? "down")
        let nextLine = line("w$") + 1
        exe jumpTo . nextLine . "Gzt"
    endif
endfunction

"/* Get date and time */
function! NotepadF5()
    return strftime("%a %H:%M %d %b %Y")
endfunction

"/* http://superuser.com/questions/697847/cant-run-vimdiff-7-4-on-windows-7
" * (see ``set diffexpr='' above) */
function! MyDiff_Fix_Vim74_E97_QuoteBug()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    if $VIMRUNTIME =~ ' '
        if &sh =~ '\<cmd'
            if empty(&shellxquote)
                let l:shxq_sav = ''
                set shellxquote&
            endif
            let cmd = '"' . $VIMRUNTIME . '\diff"'
        else
            let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
        endif
    else
        let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
    if exists('l:shxq_sav')
       let &shellxquote=l:shxq_sav
    endif
 endfunction

"/******************************************************************************
" * Scripts
" ******************************************************************************/

"/******************************************************************************
" * Handle large files
" * http://vim.wikia.com/wiki/Faster_loading_of_large_files
" */

"/* Specify size threshold to apply config changes */
let g:LargeFile = 1024 * 1024 * 100
augroup LargeFile 
    autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END

function LargeFile()
    "; no syntax highlighting etc
    set eventignore+=FileType
    "; save memory when other file is viewed
    setlocal bufhidden=unload
    "; is read-only (write with :w new_filename)
    setlocal buftype=nowrite
    "; no undo possible
    setlocal undolevels=-1
    "; display message
    autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction

"; -----
"; Preferred modeline for _vimrc (the " is required to prevent source errors)
";  vim:ro:nomodifiable
