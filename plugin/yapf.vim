if exists('g:loaded_yapf')
    finish
endif
let g:loaded_yapf = 1

if !exists("YAPF(...)")
  function YAPF(...)

    let l:args = get(a:, 1, '')

    if exists("g:yapf_cmd")
      let yapf_cmd=g:yapf_cmd
    else
      let yapf_cmd="yapf"
    endif

    if exists("g:yapf_style")
      let yapf_style=" --style " . g:yapf_style
    else
      let yapf_style=""
    endif

    if !executable(yapf_cmd)
      echoerr "File " . yapf_cmd . " not found. Please install it first."
      return
    endif

    let execmdline=yapf_cmd . " " . yapf_style . " " . l:args
    let current_line = line('.')
    " save current cursor position
    let current_cursor = getpos(".")
    silent execute "0,$!" . execmdline
    " restore cursor
    call setpos('.', current_cursor)
    if v:shell_error != 0
      " Shell command failed, so open a new buffer with error text
      execute 'normal! gg"ayG'
      silent undo
      execute 'normal! ' . current_line . 'G'
      " restore cursor position
      call setpos('.', current_cursor)
      silent new
      silent put a
    end
  endfunction

  command! -nargs=? -bar Yapf call Yapf(<f-args>)
endif
