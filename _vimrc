"; +---------------------------------------------------------------------------+
"; | System                                                                    |
"; +---------------------------------------------------------------------------+

"; Source the system _vimrc (which also loads vimrc_example.vim)
source $VIM/_vimrc

"; +----------------------------------------------------------------------------
"; | Change any $VIM/_vimrc settings

"; Reset textwidth
au! vimrcEx FileType text setlocal tw&

"; http://superuser.com/questions/697847/cant-run-vimdiff-7-4-on-windows-7
set diffexpr=MyDiff_Fix_Vim74_E97_QuoteBug()

"; +----------------------------------------------------------------------------
"; | Other settings

"let profile_dir = $HOME/vim
"let profile_dir = $VIM . "/profiles/lem/vim"
"
"source $VIM/profiles/lem/colors/gray_on_black.vim
"exec "source " . profile_dir . "/colors/gray_on_black.vim"
"
"let STL = "%<%f%m%r%(\ (type:%Y)%)%(\ %a%)\ %h%w%q%=%-30.(%l(%p%%)/%L,%c%V%)\ %P"
"let STL = "%<%f%m%r%(\\ (type:%Y)%)%(\\ %a%)\\ %h%w%q%=%-30.(%l(%p%%)/%L,%c%V%)\\ %P"

"; See $VIMRUNTIME\doc\usr_21.txt: *21.3*	Remembering information; viminfo
"; Also see ":help viminfo"
"; Default is '100,<50,s10,h,rA:,rB:
"set viminfo+=f1
set viminfo+=c

"; +---------------------------------------------------------------------------+
"; | Options                                                                   |
"; | (See ":options" for interactive settings and ":help options" for details) |
"; +---------------------------------------------------------------------------+

set nobk wb nows
set ts=4 sw=4 tw=0 shm=at go-=T 
set viewdir=$HOME/vimfiles/views
set sessionoptions+=unix,slash,resize
set listchars+=tab:>-,trail:-

";
"; Status line
";
"set statusline=%<%f%m%r%(\ (type:%Y)%)%(\ %a%)\ %h%w%q%=%-30.(%l(%p%%)/%L,%c%V%)\ %P
"set statusline=%<%f%m%r%(\ (%Y)%)%(\ %a%)\ %h%w%q%=%-30.(%l(%p%%)/%L,%c%V%)\ %P
"set statusline=%<%f\ %m%r%=%-30(%(\ (%Y)%)%(%a%)\ %h%w%q%)\ %5(<%n>%)\ %-30.(%l(%p%%)/%L,%c%V%)\ %P
"set statusline=%<%f\ %m%r%=%-30(%(\ (%Y)%)%(%a%)\ %h%w%q%)\ %5(<%n>%)\ %-30.(%l/%L(%p%%),%c%V%)\ %P
set statusline=%<%f\ %m%r%=%-30(%(\ (%Y)%)%(%a%)\ %h%w%q%)\ %5(<%n>%)\ %-30.(%l/%L(%p%%),%c%V%)\ #%{winnr()}\ %P
set rulerformat=%60(%m%r%(\ (%Y)%)%(%a%)%(\ %h%w%q%)\ %=<%n>\ %-30.(%l/%L(%p%%),%c%V%)\ #%{winnr()}\ %P%)
"exec "set statusline=".STL
"exec "set rulerformat=".STL
"set rulerformat=%<%f%m%r%(\ (type:%Y)%)%(\ %a%)\ %h%w%q%=%-30.(%l(%p%%)/%L,%c%V%)\ %P

"; +---------------------------------------------------------------------------+
"; | Colors                                                                    |
"; +---------------------------------------------------------------------------+

"colo darkblue_lem
"runtime colors/darkblue_lem.vim

"; +---------------------------------------------------------------------------+
"; | Fonts                                                                     |
"; +---------------------------------------------------------------------------+

if has('gui_running')
  set guifont=Lucida_Console:h10:cANSI
endif

"; +---------------------------------------------------------------------------+
"; | Mappings                                                                  |
"; +---------------------------------------------------------------------------+

";
"; Remove
";

"; Unmap some unwanted/redundant mswin.vim bindings
unmap <C-Y>
iunmap <C-Y>
iunmap <C-A>
"unmap <C-Z>

";
"; Alternate defaults
";

"; Section mappings (see motion.txt)
map [[ ?{<CR>w99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>

"; increment/decrement numbers
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>

";
"; Custom
";

"; My custom section breaks
imap <F5> <C-R>=NotepadF5()<C-M>
imap <S-F5> <F6><ESC>o<F5><CR><CR>
imap <F6> <ESC>79i=<ESC>o

"; Window navigation
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

"; +---------------------------------------------------------------------------+
"; | Functions                                                                 |
"; +---------------------------------------------------------------------------+

"; Get date and time
:function! NotepadF5()
:	return strftime("%a %H:%M %d %b %Y")
:endfunction

"; http://superuser.com/questions/697847/cant-run-vimdiff-7-4-on-windows-7
"; (see ``set diffexpr='' above)
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

"; +---------------------------------------------------------------------------+
"; | Scripts                                                                   |
"; +---------------------------------------------------------------------------+

"; +----------------------------------------------------------------------------
"; | Handle large files
"; | http://vim.wikia.com/wiki/Faster_loading_of_large_files

"; Specify size threshold to apply config changes
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

"; Preferred modeline for _vimrc (the " is required to prevent source errors)
";	vim:ro:nomodifiable
