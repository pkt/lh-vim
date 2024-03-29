"=============================================================================
" $Id$
" File:		autoload/lh/dev/naming.vim                        {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	0.0.2
" Created:	05th Oct 2009
" Last Update:	$Date$
"------------------------------------------------------------------------
" Description:
" - Naming policies for programming styles
"
"------------------------------------------------------------------------
" History:
" 	v0.0.2: vim parameters specificities taken into account
" TODO:
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------

" ## Misc Functions     {{{1
" # Version {{{2
let s:k_version = 001
function! lh#dev#naming#version()
  return s:k_version
endfunction

" # Debug {{{2
function! lh#dev#naming#verbose(level)
  let s:verbose = a:level
endfunction

function! s:Verbose(expr)
  if exists('s:verbose') && s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#dev#naming#debug(expr)
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1
function! s:Option(option, ft, default)
  return lh#dev#option#get('naming_'.a:option, a:ft, a:default)
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1
" Tool functions {{{2
" Function:lh#dev#naming#to_upper_camel_case(identifier)   {{{3
function! lh#dev#naming#to_upper_camel_case(identifier)
  let identifier = substitute(a:identifier, '\%(^\|_\)\(\a\)', '\u\1', 'g')
  return identifier
endfunction

" Function:lh#dev#naming#to_lower_camel_case(identifier)   {{{3
function! lh#dev#naming#to_lower_camel_case(identifier)
  let identifier = substitute(a:identifier, '_\(\a\)', '\u\1', 'g')
  let identifier = substitute(identifier, '^\(\a\)', '\l\1', '')
  return identifier
endfunction

" Function:lh#dev#naming#to_underscore(identifier)         {{{3
function! lh#dev#naming#to_underscore(identifier)
  "todo: handle constant-like identifiers
  "test with lh#foo#FooBar ...
  let identifier = substitute(a:identifier, '\%(^\|[^A-Za-z0-9]\)\zs\(\u\)', '\l\1', '')
  let identifier = substitute(identifier, '\l\zs\(\u\)', '_\l\1', 'g')
  return identifier
endfunction

" Identifiers (var, getter, global, ...) {{{2
" Function: lh#dev#naming#variable(variable [, filetype] ) {{{3
function! lh#dev#naming#variable(name, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let strip_re    = s:Option('strip_re', ft, '^\%([gG]et\|[sS]et\|[mgsp]_\|_\+\)\=\(.\{-}\)\%(_\=\)$')
  let strip_subst = s:Option('strip_subst', ft, '\l\1')
  let res = substitute(a:name, strip_re, strip_subst, '')
  return res
endfunction

" Function: lh#dev#naming#getter(variable [, filetype] ) {{{3
function! lh#dev#naming#getter(variable, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let get_re    = s:Option('get_re', ft, '.*')
  let get_subst = s:Option('get_subst', ft, 'get\u&')
  let variable = lh#dev#naming#variable(a:variable, ft)
  let res = substitute(variable, get_re, get_subst, '' )
  let res = lh#dev#naming#function(res, ft)
  return res
endfunction

" Function: lh#dev#naming#setter(variable [, filetype] ) {{{3
function! lh#dev#naming#setter(variable, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let set_re    = s:Option('set_re', ft, '.*')
  let set_subst = s:Option('set_subst', ft, 'set\u&')
  let variable = lh#dev#naming#variable(a:variable, ft)
  let res = substitute(variable, set_re, set_subst, '' )
  let res = lh#dev#naming#function(res, ft)
  return res
endfunction

" Function: lh#dev#naming#ref_getter(variable [, filetype] ) {{{3
" Full getter that gives a total access to everything.
function! lh#dev#naming#ref_getter(variable, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let ref_re    = s:Option('ref_re', ft, '.*')
  let ref_subst = s:Option('ref_subst', ft, 'ref\u&')
  let variable = lh#dev#naming#variable(a:variable, ft)
  let res = substitute(variable, ref_re, ref_subst, '' )
  return res
endfunction

" Function: lh#dev#naming#proxy_getter(variable [, filetype] ) {{{3
" Getter that gives a total access through a proxy
function! lh#dev#naming#proxy_getter(variable, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let proxy_re    = s:Option('proxy_re', ft, '.*')
  let proxy_subst = s:Option('proxy_subst', ft, 'proxy\u&')
  let variable = lh#dev#naming#variable(a:variable, ft)
  let res = substitute(variable, proxy_re, proxy_subst, '' )
  return res
endfunction

" Function: lh#dev#naming#global(variable [, filetype] ) {{{3
function! lh#dev#naming#global(variable, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let global_re    = s:Option('global_re', ft, '.*')
  let global_subst = s:Option('global_subst', ft, 'g_&')
  let variable = lh#dev#naming#variable(a:variable, ft)
  let res = substitute(variable, global_re, global_subst, '' )
  return res
endfunction

" Function: lh#dev#naming#local(variable [, filetype] ) {{{3
function! lh#dev#naming#local(variable, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let local_re    = s:Option('local_re', ft, '.*')
  let local_subst = s:Option('local_subst', ft, '&')
  let variable = lh#dev#naming#variable(a:variable, ft)
  let res = substitute(variable, local_re, local_subst, '' )
  return res
endfunction

" Function: lh#dev#naming#member(variable [, filetype] ) {{{3
function! lh#dev#naming#member(variable, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let member_re    = s:Option('member_re', ft, '.*')
  let member_subst = s:Option('member_subst', ft, 'm_&')
  let variable = lh#dev#naming#variable(a:variable, ft)
  let res = substitute(variable, member_re, member_subst, '' )
  return res
endfunction

" Function: lh#dev#naming#static(variable [, filetype] ) {{{3
function! lh#dev#naming#static(variable, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let static_re    = s:Option('static_re', ft, '.*')
  let static_subst = s:Option('static_subst', ft, 's_&')
  let variable = lh#dev#naming#variable(a:variable, ft)
  let res = substitute(variable, static_re, static_subst, '' )
  return res
endfunction

" Function: lh#dev#naming#constant(variable [, filetype] ) {{{3
function! lh#dev#naming#constant(variable, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let constant_re    = s:Option('constant_re', ft, '.*')
  let constant_subst = s:Option('constant_subst', ft, '\U&\E')
  let variable = lh#dev#naming#variable(a:variable, ft)
  let res = substitute(variable, constant_re, constant_subst, '' )
  return res
endfunction

" Function: lh#dev#naming#param(variable [, filetype] ) {{{3
" Example to have parameters post-fixed with '_':
"   :let b:cpp_naming_param_re = '\(.\{-}\)_\=$'
"   :let b:cpp_naming_param_subst = '\1_'
function! lh#dev#naming#param(variable, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let param_re    = s:Option('param_re', ft, '.*')
  let param_subst = s:Option('param_subst', ft, '&')
  let variable = lh#dev#naming#variable(a:variable, ft)
  let res = substitute(variable, param_re, param_subst, '' )
  return res
endfunction

" Function: lh#dev#naming#function(fn, [, filetype]) {{{3
function! lh#dev#naming#function(fn, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let naming_policy = s:Option('function', ft, 'lowerCamelCase')
  return lh#dev#naming#according_to_policy(a:fn, naming_policy)
endfunction

" Function: lh#dev#naming#function(type, [, filetype]) {{{3
function! lh#dev#naming#type(type, ...)
  let ft = (a:0 == 1) ? a:1 : &ft
  let naming_policy = s:Option('type', ft, 'UpperCamelCase')
  "  todo: handle prefixs and postfixs
  let type_re    = s:Option('type_re', ft, '.*')
  let type_subst = s:Option('type_subst', ft, '&')
  let res = lh#dev#naming#according_to_policy(a:type, naming_policy)
  let res = substitute(res, type_re, type_subst, '')
  return res
endfunction

" Function: lh#dev#naming#according_to_policy(parts, policy) {{{3
function! lh#dev#naming#according_to_policy(parts, naming_policy)
  if type(a:parts) == type([])
    let parts = copy(a:parts)
    let case = a:naming_policy == 'UpperCamelCase' ? '\u' : '\l'
    let parts[0] = substitute(parts[0], '^.', case.'&', 'g')
    let case = a:naming_policy =~ '.*CamelCase' ? '\u' : '\l'
    let tail =  map(parts[1:], 'substitute(v:val, "^.", case."&", "g")')
    let sep = a:naming_policy == 'snake_case' ? '_' : ''
    let res = join([parts[0]] + tail, sep)
    return res
  else " split at '_' and uppercases, ad use this function again.
    let parts = split(a:parts, '\ze[A-Z]\|_')
    return lh#dev#naming#according_to_policy(parts, a:naming_policy)
  endif
endfunction

"------------------------------------------------------------------------
" ## Predefined constants {{{1

" # VimL {{{2
" todo: differentiate vim arg use from arg names in function signature
LetIfUndef g:vim_naming_param_re     '\%([algsbwt]:\)\=\(.*\)'
LetIfUndef g:vim_naming_param_subst  'a:\1'
LetIfUndef g:vim_naming_static_re     '\%([algsbwt]:\)\=\(.*\)'
LetIfUndef g:vim_naming_static_subst 's:\1'
LetIfUndef g:vim_naming_global_re     '\%([algsbwt]:\)\=\(.*\)'
LetIfUndef g:vim_naming_global_subst 'g:\1'

" # Java, recommended coding style {{{2
LetIfUndef g:java_naming_get_subst 'get\u&'
LetIfUndef g:java_naming_set_subst 'set\u&'
LetIfUndef g:java_naming_function  'lowerCamelCase'
" # C#, recommended coding style  {{{2
LetIfUndef g:cs_naming_get_subst   'Get\u&'
LetIfUndef g:cs_naming_set_subst   'Set\u&'
LetIfUndef g:cs_naming_function    'UpperCamelCase'

"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
