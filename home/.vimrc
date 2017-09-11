let tmpdir = $HOME . '/' . '.vim' . '/' . 'tmp'

if !isdirectory(tmpdir)
    call mkdir(tmpdir, 'p')
endif

execute "set backupdir=".tmpdir . '//'
execute "set directory=".tmpdir . '//'
execute "set undodir=".tmpdir . '//'
