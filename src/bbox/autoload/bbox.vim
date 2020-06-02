" -----------------------------------------------------------------------------
" File: bbox.vim
" Description: Retro groove color scheme for Vim
" Author: morhetz <morhetz@gmail.com>
" Source: https://github.com/morhetz/bbox
" Last Modified: 09 Apr 2014
" -----------------------------------------------------------------------------

function! bbox#invert_signs_toggle()
  if g:bbox_invert_signs == 0
    let g:bbox_invert_signs=1
  else
    let g:bbox_invert_signs=0
  endif

  colorscheme bbox
endfunction

" Search Highlighting {{{

function! bbox#hls_show()
  set hlsearch
  call BboxHlsShowCursor()
endfunction

function! bbox#hls_hide()
  set nohlsearch
  call BboxHlsHideCursor()
endfunction

function! bbox#hls_toggle()
  if &hlsearch
    call bbox#hls_hide()
  else
    call bbox#hls_show()
  endif
endfunction

" }}}

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
