set nobackup
set nowritebackup
set noswapfile
set noundofile
set noshelltemp
set nomodeline
set viminfo=
set secure

" Example invocation:
"
"   alias vimsec="vim -N -n -i NONE -u ~/secure.vim"
"   alias gvimsec="g$(alias vimsec | sed -e "s/-u/-U/" -e "s/\(.*\)'\(.*\)'/\2/")"
