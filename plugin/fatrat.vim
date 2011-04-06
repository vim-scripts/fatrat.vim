" Filename:      fatrat.vim
" Description:   Open all the runtime files for a filetype
" Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>

if exists('g:fatrat_loaded') || &cp
    finish
endif

let g:fatrat_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

command! -bar -nargs=? -complete=filetype FatRatEdit :call s:EditScripts(<q-args>)
command! -bar -nargs=? -complete=filetype FatRatList :call s:ListScripts(<q-args>)

function! s:EditScripts(type)
    for script in s:GetScripts(a:type)
        execute 'edit '.script
    endfor
endfunction

function! s:ListScripts(type)
    for script in s:GetScripts(a:type)
        echo script
    endfor
endfunction

function! s:GetScripts(type)
    let ft = a:type
    if len(ft) == 0
        let ft = &ft
    endif
    let scripts = []
    if len(ft) > 0
        for dir in ['ftplugin', 'syntax', 'indent']
            for p in ['.vim', '/*.vim', '_*.vim']
                call extend(scripts, s:GetFiles(dir.'/'.ft.p))
            endfor
        endfor
    endif
    return scripts
endfunction

function! s:GetFiles(pattern)
    return split(globpath(&rtp, a:pattern), '\n')
endfunction

let &cpo = s:save_cpo
