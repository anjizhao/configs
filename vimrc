
" show line numbers in grey
set number
highlight LineNr ctermfg=grey

" use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab

" strip trailing whitespace for python files
autocmd BufWritePre *.py %s/\s\+$//e


