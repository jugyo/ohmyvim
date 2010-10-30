" From http://items.sjbach.com/319/configuring-vim-right
set nocp
set hidden
let mapleader = ","
set history=1000
runtime macros/matchit.vim
set wildmenu
set wildmode=list:longest
set ignorecase 
set smartcase
set title
set scrolloff=3
set backupdir=~/.vim/backups,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim/backups,~/.tmp,~/tmp,/var/tmp,/tmp

nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
set backspace=indent,eol,start 
 
" File-type highlighting and configuration.
" Run :filetype (without args) to see what you may have
" to turn on yourself, or just set them all to be sure.
syntax on
colorscheme twilight
filetype on
filetype plugin on
filetype indent on
set incsearch
set shortmess=atI
set visualbell
" From http://weblog.jamisbuck.org/2008/11/17/vim-follow-up
set grepprg=ack
set grepformat=%f:%l:%m
set tabstop=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab
autocmd FileType make     set noexpandtab
autocmd FileType python   set noexpandtab
set ruler
set number
set hlsearch
syntax on
 	
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

let g:fuzzy_ignore = "*.log"
let g:fuzzy_matching_limit = 70

map <leader>t :FuzzyFinderTextMate<CR>
map <leader>b :FuzzyFinderBuffer<CR>
" From http://biodegradablegeek.com/2007/12/using-vim-as-a-complete-ruby-on-rails-ide/
set cf  " Enable error files & error jumping.
set clipboard+=unnamed  " Yanks go on clipboard instead.
set autowrite  " Writes on make/shell commands
set showmatch
set laststatus=2

" Run Rspec for the current spec file
function! RunRspec()
ruby << EOF
  buffer = VIM::Buffer.current
  spec_file = VIM::Buffer.current.name
  command = "ruby ~/.vim/bin/run_rspec.rb #{spec_file}"
  print "Running Rspec for #{spec_file}. Results will be displayed in Firefox."
  system(command)
EOF
endfunction
map <F7> :w<CR> :call RunRspec()<cr>
map <F6> :A<CR> 

set list listchars=tab:>-,trail:.,extends:>

" BufExplorer
nmap <c-l> :BufExplorer<CR>

" Eval Buffer
function! EvalBuffer()
ruby << EOF
  lines = []
  $curbuf.count.times do |i|
    lines << $curbuf[i + 1]
  end
  eval(lines.join("\n"))
EOF
endfunction

" Eval line
function! EvalLine() range
  let str = ""
  for i in range(a:firstline, a:lastline)
    let str = str . getline(i) . "\n"
  endfor
ruby << EOF
  require 'stringio'
  $stdout = StringIO.new
  begin
    result = eval(VIM.evaluate('str')).inspect
  rescue Exception => e
    result = e.class.name
  end
  unless $stdout.string.empty?
    result = $stdout.string
  end
  result.split(/\n/).reverse_each do |line|
    $curbuf.append VIM.evaluate('a:lastline').to_i, line
  end
EOF
endfunction

map <leader>r :call EvalBuffer()<CR>
map <leader>e :call EvalLine()<CR>
map <leader>s :source ~/.vimrc<CR>
