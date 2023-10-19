let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -sfLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

:set number
:set cursorline
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set whichwrap+=<,>,h,l,[,]

:set ignorecase
:set smartcase
:set hlsearch
:set incsearch

:filetype plugin on
:set omnifunc=syntaxcomplete#Complete

call plug#begin()
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-sleuth'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'preservim/nerdtree'
  Plug 'preservim/tagbar'
  Plug 'vim-airline/vim-airline'
  Plug 'ap/vim-css-color'
  Plug 'rafi/awesome-vim-colorschemes'
  Plug 'jayli/vim-easycomplete'
  Plug 'mg979/vim-visual-multi'
call plug#end()

nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <C-l> :NERDTreeToggle<CR>
nnoremap <F8> :TagbarToggle<CR>

noremap gr :EasyCompleteReference<CR>
noremap gd :EasyCompleteGotoDefinition<CR>
noremap rn :EasyCompleteRename<CR>
noremap gb :BackToOriginalBuffer<CR>

:colorscheme jellybeans

" tmux sends xterm-style keys when xterm-keys option is on
if &term =~ '^screen'
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" copy & paste
nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gP
