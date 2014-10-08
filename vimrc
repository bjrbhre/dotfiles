" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2000 Jan 06
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"		for VMS:  sys$login:.vimrc
set incsearch
set mouse=a
set nowrap
set sw=2
set ts=2
set expandtab
set ignorecase
set smartcase
set modelines=0
set number
language fr_FR
set encoding=utf-8
set fileencoding=utf-8
" set matchpairs=""
filetype plugin on
filetype indent on

"----------------- personnal mappings"
map <tab> :tabnext<CR>
map <C-tab> <ESC>:tabnew<CR>

" set vb
au BufNewFile,BufRead *.xml,*.htm,*.html set foldmethod=indent foldlevel=12

autocmd BufRead,BufNewFile *.pig set filetype=pig
" colorscheme darkrobot
colorscheme desert
set tags=TAGS;~
" $MILORD/debug/TAGS,$OUTILSRO/debug/TAGS
"set makeprg=cd\ ../../debug/&&gmake\ -j2

set complete=.,d,i,b,w,t,u

function! SwitchSourceHeader()
"update!
if (expand ("%:t") == expand ("%:t:r") . ".cc")
	find %:t:r.hh
else
	find %:t:r.cc
endif
endfunction


function DavSwitch()
	let monfile=expand("%:t:r")
	if (expand ("%:t") == monfile . ".cc" && (filereadable(monfile . ".hh")) )
		return (monfile . ".hh")
	elseif (expand ("%:t") == monfile . ".hh")
		if (filereadable(monfile . ".cc"))
			return (monfile . ".cc")
		elseif (filereadable(monfile . "Defs.hh"))
			return (monfile . "Defs.hh")
		elseif (filereadable(substitute(monfile, "Defs", ".hh", "")))
			return (substitute(monfile, "Defs", ".hh", ""))
		endif
	endif
	return %
endfunction

nmap ,h :e <C-R>=DavSwitch()<CR><CR>
nmap ,s :sp <C-R>=DavSwitch()<CR><CR>
nmap ,v :vs <C-R>=DavSwitch()<CR><CR>

" nmap ,h :call SwitchSourceHeader()<CR>
" nmap ,s :sp <CR> :call SwitchSourceHeader()<CR>
" nmap ,v :vs <CR> :call SwitchSourceHeader()<CR>


function InsertTabWrapper(direction)
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	elseif "backward" == a:direction
		return "\<c-p>"
	endif
	return "\<c-n>"
endfunction

inoremap <tab> <c-r>=InsertTabWrapper("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper("backward")<cr>

autocmd BufEnter * cd %:p:h

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" set background=darkslategray
set nocompatible
" hi Comment guibg=DarkGreen
" hi Comment guifg=yellow
" set guifontset=lucindasans-10
set guifont=Fixed\ 10
" set guifont=-b&h-lucidatypewriter-medium-r-normal-*-*-140-*-*-m-*-iso8859-1
" set guifont=-b&h-lucida\ sans\ typewriter-medium-r-normal-*-*-120-*-*-m-*-iso8859-1
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set nobackup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
" if &t_Co > 2 || has("gui_running")
syntax on
set hlsearch
" endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

" In text files, always limit the width of text to 78 characters
autocmd BufRead *.txt set tw=78

augroup cprog
" Remove all cprog autocommands
au!

" When starting to edit a file:
"   For C and C++ files set formatting of comments and set C-indenting on.
"   For other files switch it off.
"   Don't change the order, it's important that the line with * comes first.
autocmd FileType *      set formatoptions=tcql nocindent comments&
autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END

augroup gzip
" Remove all gzip autocommands
au!

" Enable editing of gzipped files
" set binary mode before reading the file
autocmd BufReadPre,FileReadPre	*.gz,*.bz2 set bin
autocmd BufReadPost,FileReadPost	*.gz call GZIP_read("gunzip")
autocmd BufReadPost,FileReadPost	*.bz2 call GZIP_read("bunzip2")
autocmd BufWritePost,FileWritePost	*.gz call GZIP_write("gzip")
autocmd BufWritePost,FileWritePost	*.bz2 call GZIP_write("bzip2")
autocmd FileAppendPre			*.gz call GZIP_appre("gunzip")
autocmd FileAppendPre			*.bz2 call GZIP_appre("bunzip2")
autocmd FileAppendPost		*.gz call GZIP_write("gzip")
autocmd FileAppendPost		*.bz2 call GZIP_write("bzip2")

" After reading compressed file: Uncompress text in buffer with "cmd"
fun! GZIP_read(cmd)
" set 'cmdheight' to two, to avoid the hit-return prompt
let ch_save = &ch
set ch=3
" when filtering the whole buffer, it will become empty
let empty = line("'[") == 1 && line("']") == line("$")
let tmp = tempname()
let tmpe = tmp . "." . expand("<afile>:e")
" write the just read lines to a temp file "'[,']w tmp.gz"
execute "'[,']w " . tmpe
" uncompress the temp file "!gunzip tmp.gz"
execute "!" . a:cmd . " " . tmpe
" delete the compressed lines
'[,']d
" read in the uncompressed lines "'[-1r tmp"
set nobin
execute "'[-1r " . tmp
" if buffer became empty, delete trailing blank line
if empty
normal Gdd''
endif
" delete the temp file
call delete(tmp)
let &ch = ch_save
" When uncompressed the whole buffer, do autocommands
if empty
execute ":doautocmd BufReadPost " . expand("%:r")
endif
endfun

" After writing compressed file: Compress written file with "cmd"
fun! GZIP_write(cmd)
if rename(expand("<afile>"), expand("<afile>:r")) == 0
execute "!" . a:cmd . " <afile>:r"
endif
endfun

" Before appending to compressed file: Uncompress file with "cmd"
fun! GZIP_appre(cmd)
execute "!" . a:cmd . " <afile>"
call rename(expand("<afile>:r"), expand("<afile>"))
endfun

augroup END

" This is disabled, because it changes the jumplist.  Can't use CTRL-O to go
" back to positions in previous files more than once.
if 0
" When editing a file, always jump to the last cursor position.
" This must be after the uncompress commands.
autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
endif

endif " has("autocmd")
