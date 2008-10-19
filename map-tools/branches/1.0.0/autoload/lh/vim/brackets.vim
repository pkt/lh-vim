"=============================================================================
" $Id$
" File:		brackets.vim                                           {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://hermitte.free.fr/vim/>
" Version:	�version�
" Created:	20th Mar 2008
" Last Update:	$Date$
"------------------------------------------------------------------------
" Description:	�description�
" 
"------------------------------------------------------------------------
" Installation:	�install details�
" History:	�history�
" TODO:		�missing features�
" }}}1
"=============================================================================

"------------------------------------------------------------------------
let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------

" Inserts '<>' on '<', except after an if or within comment. {{{3
" This rule knows an exception : within a string, or after a '\', '<' is
" always converted to '<>'.
" Does not handle special characters like ''<' and ''>'
" Updated on 08th May 2004
function! lh#vim#brackets#lt()
  let l = getline('.')
  let c = col('.') - 1
  let syn = synIDattr(synID(line('.'),c,1),'name') 
  if (l[c-1] != '\') && (syn !~? '\(string\)\|\(character\)')
    if (syn =~? 'comment') || (l =~ '\m.*\<\(if\|while\)\s*.*')
      return '<'
    endif 
  endif
  if exists('b:usemarks') && b:usemarks
    return '<>' . "!mark!\<esc>".strlen(Marker_Txt())."\<left>i"
  else
    return '<>' . "\<Left>"
  endif
endfunction

" Inserts '""' on '"', except for comments {{{3
" (supposed equivalent to empty lines)
" Heuristic used:
" - after ')', it can not be a string => comment
" - in the beginning of a line ('^\s*$') => comment
" - otherwise => string
function! lh#vim#brackets#dquotes() 
  " TEST: OK sans imaps.vim
  let l = strpart(getline(line('.')), 0, col('.')-1)
  if l =~ '\m)\s*$\|^\s*$'
    return '"'
  elseif exists("b:usemarks") && b:usemarks == 1
    return '"!cursorhere!"!mark!'
  else
    return '""'. "\<Left>"
  endif
endfunction
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker: