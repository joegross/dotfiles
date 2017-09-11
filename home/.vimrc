let vimdir = $HOME . '/' . '.vim'
let backup = vimdir . '/' . 'backup'
let swap = vimdir . '/' . 'swap'
let undo = vimdir . '/' . 'undo'

if !isdirectory(backup)
    call mkdir(backup, 'p')
endif

if !isdirectory(swap)
    call mkdir(swap, 'p')
endif

if !isdirectory(undo)
    call mkdir(undo, 'p')
endif

execute "set backupdir=".backup . '//'
execute "set directory=".swap . '//'
execute "set undodir=".undo . '//'
