call plug#begin()
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'fatih/molokai'
Plug 'AndrewRadev/splitjoin.vim'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'w0rp/ale'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'google/vim-jsonnet'
Plug 'airblade/vim-gitgutter'
Plug 'wincent/terminus'
Plug 'vimwiki/vimwiki'
Plug 'vim-scripts/grep.vim'
call plug#end()
set nocompatible
syntax on
filetype plugin indent on
set backspace=indent,eol,start

" airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme="minimalist"
let g:airline_powerline_fonts = 1

" ale config
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
let g:airline#extensions#ale#enabled = 1

" deoplete/neosnippet config
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
inoremap <expr><tab>  pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<s-tab>"
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

let g:go_snippet_engine = "neosnippet"

let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai

let mapleader = ","
set number
autocmd FileType * setlocal tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType go setlocal tabstop=4|set noexpandtab|set shiftwidth=4 
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype typescript setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype jsonnet setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType make setlocal noexpandtab
set ignorecase
set smartcase
set autowrite
let g:go_list_type = "quickfix"
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <Leader>u :GoReferrers<CR>

autocmd FileType go nmap <Leader>ds :GoDebugStart<CR>
autocmd FileType go nmap <Leader>dt :GoDebugTest<CR>
autocmd FileType go nmap <Leader>dq :GoDebugStop<CR>
autocmd FileType go nmap <Leader>db :GoDebugBreakpoint<CR>
autocmd FileType go nmap <Leader>dc :GoDebugContinue<CR>
autocmd FileType go nmap <Leader>dn :GoDebugNext<CR>
autocmd FileType go nmap <Leader>ds :GoDebugStep<CR>
autocmd FileType go nmap <Leader>ds :GoDebugStepOut<CR>

let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_test_timeout = "30s"
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
autocmd FileType go nmap <Leader>i <Plug>(go-info)
let g:go_auto_type_info = 1
" let g:go_auto_sameids = 1

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = 'node_modules/\|DS_Store\|\.git/\|vendor/\|dist/'

" use jsx formatting in .js files
let g:jsx_ext_required = 0

let g:jsonnet_fmt_options = ' -i -n 2 --string-style s'

" use more memory for syntax highlighting big files
set mmp=2000 " default 1000

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" grep.vim
nnoremap <silent> <leader>f :Rgrep<CR>
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules'

"" Git
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gsh :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

set wildmode=list:longest,list:full

"" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

