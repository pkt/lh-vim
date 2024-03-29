"=============================================================================
" $Id$
" File:         autoload/lh/dev/style.vim                         {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:      1.1.6
let s:k_version = 116
" Created:      12th Feb 2014
" Last Update:  $Date$
"------------------------------------------------------------------------
" Description:
"       Functions related to help implement coding styles (e.g. Allman or K&R
"       way of placing brackets, must there be spaces after ';' in for control
"       statements, ...)
"
"       Defines:
"       - support function for :AddStyle
"       - lh#dev#style#get() that returns the style chosen for the given
"         filetype
"
" Tests:
"       See tests/lh/dev-style.vim
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim


"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#style#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = 0
function! lh#dev#style#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#dev#style#debug(expr)
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1

" # Main Style functions {{{2
" Function: lh#dev#style#clear() {{{3
function! lh#dev#style#clear()
  let s:style = {}
endfunction

" Function: lh#dev#style#get(ft) {{{3
" priority:
" 1- same ft && buffer local
" 2- same ft && global
" 3- inferior ft (C++ inherits C stuff) && buffer local
" 4- inferior ft (C++ inherits C stuff) && global
" ...
" n-1- for all ft && buffer local
" n- for all ft && global
"
" TODO: priority n-1 seems much better than priority 2: I may have to change
" that
function! lh#dev#style#get(ft)
  let res = {}

  let fts = lh#dev#option#inherited_filetypes(a:ft) + ['*']
  let bufnr = bufnr('%')

  for [pattern, hows] in items(s:style)
    let new_repl = {}
    let new_repl[pattern] = ''

    for how in hows
      if how.local != -1 && how.local != bufnr
        continue
      endif

      let ft = index(fts, how.ft)
      if ft < 0 | continue | endif

      if empty(new_repl[pattern])
        let new_repl[pattern] = how.replacement
        let new_repl.ft = ft
      else
        let old_ft = get(new_repl, 'ft', -1)
        if ft < old_ft
          let new_repl[pattern] = how.replacement
          let new_repl.ft = ft
        elseif ft == old_ft
          if how.local == bufnr " then we override global setting
            let new_repl[pattern] = how.replacement
          endif
        endif " compare fts
      endif " compare to previous definition
    endfor
    if !empty(new_repl[pattern])
      unlet new_repl.ft
      call extend(res, new_repl)
    endif
  endfor

  return res
endfunction

" Function: lh#dev#style#apply(text [, ft]) {{{3
function! lh#dev#style#apply(text, ...) abort
  let ft = a:0 == 0 ? &ft : a:1
  let styles = lh#dev#style#get(ft)
  let keys = reverse(sort(map(keys(styles), 'escape(v:val, "\\")'), 'lh#dev#style#_str_cmp'))
  let sKeys = join(keys, '\|')
  " Using a sorted list of keys permits to avoid triggering "}" style on
  " "class {};" when there is a "};" style.
  let res = substitute(a:text, sKeys, '\=lh#dev#style#_get_replacement(styles, submatch(0), keys)', 'g')
  return res
endfunction

" # lh-brackets Adapters for snippets {{{2
" Function: lh#dev#style#surround() {{{3
function! lh#dev#style#surround(
      \ begin, end, isLine, isIndented, goback, mustInterpret, ...) range
  let begin = lh#dev#style#apply(a:begin)
  let end   = lh#dev#style#apply(a:end)
  return call(function('Surround'), [begin, end, a:isLine, a:isIndented, a:goback, a:mustInterpret]+a:000)
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1
if !exists('s:style')
  call lh#dev#style#clear()
endif

" :AddStyle API {{{2
" Function: lh#dev#style#_add(pattern, ...) {{{3
function! lh#dev#style#_add(pattern, ...)
  " Analyse params {{{4
  let local = -1
  let ft = '*'
  for o in a:000
    if     o =~ '-b\%[uffer]'
      let local = bufnr('%')
    elseif o =~ '-ft\|-filetype'
      let ft = matchstr(o, '.*=\zs.*')
      if empty(ft)
        let ft = &ft
      endif
    else
      let repl = o
    endif
  endfor
  if !exists('repl')
    throw "Replacement text unspecified in ".string(a:000)
  endif
  " Interpret some escape sequences
  let repl = lh#dev#reinterpret_escaped_char(repl)

  " Add the new style {{{4
  let previous = get(s:style, a:pattern, [])
  " but first check whether there is already something before adding anything
  for style in previous
    if style.local == local && style.ft == ft
      let style.replacement = repl
      return
    endif
  endfor
  " This is new => add ;; note the "return" in the search loop
  let s:style[a:pattern] = previous + [ {'local': local, 'ft': ft, 'replacement': repl}]
endfunction

" Internals {{{2
" Function: lh#dev#style#_get_replacement(styles, match, keys) {{{3
function! lh#dev#style#_get_replacement(styles, match, keys) abort
  if has_key(a:styles, a:match)
    return a:styles[a:match]
  else
    " We have been called => there is a match!
    let idx = lh#list#match_re(a:keys, a:match)
    return substitute(a:match, a:match, a:styles[a:keys[idx]], '')
  endif
endfunction

" Function: lh#dev#style#_str_cmp(lhs, rhs) {{{3
" For an unknown reason, 
"    echo sort(['{ *//', '{', 'a', 'b'])
" gives: ['a', 'b', '{ *//', '{']
" While
"    sort(['{ *//', '{', 'a', 'b'], function('lh#dev#style#_str_cmp'))
" gives the correct: ['a', 'b', '{', '{ *//']
function! lh#dev#style#_str_cmp(lhs, rhs) abort
  let res = a:lhs <  a:rhs ? -1
        \ : a:lhs == a:rhs ? 0
        \ :                  1
  return res
endfunction

"------------------------------------------------------------------------
" ## Default definitions {{{1

" # Space before open bracket in C & al {{{2
" A little space before all C constructs in C and child languages
" NB: the spaces isn't put before all open brackets
AddStyle if(     -ft=c   if\ (
AddStyle while(  -ft=c   while\ (
AddStyle for(    -ft=c   for\ (
AddStyle switch( -ft=c   switch\ (
AddStyle catch(  -ft=cpp catch\ (

" # Ignore style in C comments {{{2
" # Ignore style in comments after curly brackets {{{2
AddStyle {\ *// -ft=c \ &
AddStyle }\ *// -ft=c &

" # Multiple C++ namespaces on same line {{{2
AddStyle {\ *namespace -ft=cpp \ &
AddStyle }\ *} -ft=cpp &

" # Doxygen {{{2
" Doxygen Groups
AddStyle @{  -ft=c @{
AddStyle @}  -ft=c @}

" Doxygen Formulas
AddStyle \\f{ -ft=c \\\\f{
AddStyle \\f} -ft=c \\\\f}

" # Default style in C & al: Stroustrup {{{2
AddStyle {  -ft=c \ {\n
AddStyle }; -ft=c \n};\n
AddStyle }  -ft=c \n}\n

" # Java style {{{2
" Force Java style in Java
AddStyle { -ft=java \ {\n
AddStyle } -ft=java \n}

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
