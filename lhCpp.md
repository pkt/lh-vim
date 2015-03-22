# Features #

lh-cpp is an heterogeneous suite of helpers for C and C++ programming.

It provides the following things:
  * Smart snippets for [brackets pairs](lhCpp#Brackets.md), [control statements](lhCpp#Code_snippets.md)
  * a few [templates](#Templates.md)
  * a few [advanced wizards, and high-level features](#Wizards_and_other_high-level_features.md) to Generate classes and singletons, to Generate ready to fill-in function comments for Doxygen, Jump to a function implementation, Search for un-implemented or undeclared functions, _etc._
  * [syntax highlighting](lhCpp#Syntax_highlighting.md) for identified counter-idioms and bad practices (catch by value, assignments in conditions, throw specifications)
  * an [API](lhCpp#API.md) to build even more complex wizards and advanced features

## Text insertion facilities ##


### Brackets ###

The insertion of pair of brackets-like characters is eased thanks to [map-tool](lhBrackets.md).
| **In mode**             | **INSERT**           | **VISUAL**                | **NORMAL** |
|:------------------------|:---------------------|:--------------------------|:-----------|
| **keys**                | Expands into ..    | Surrounds the selection with ... <sup>2</sup> | Surrounds the current ... |
| `(`                   | `(<cursor>)«»`     | `(<selection>)`       | word |
| `[`                   | `[<cursor>]«»`     | <sup>1</sup>                       | <sup>1</sup>  |
| `<localleader>[`      |                    | `[<selection>]`       | word |
| `{`                   | `{<cursor>}«»`<sup>3</sup>  | `{<selection>}`       | word |
| `<localleader>{`      |                    | `{\n<selection>\n}«»` | line |
| < | `<<cursor>>«»` after `#include`, or `template` on the same line |  |  |
| `"` (1 double quote)  | `"<cursor>"«»`     | <sup>1</sup>                       | <sup>1</sup>  |
| `""`                  |                    | `"<selection>"`       | word |
| `'`                   | `'<cursor>'«»`     | <sup>1</sup>                       | <sup>1</sup>  |
| `''` (2 single quotes)|                    | `'<selection>'`       | word |
| `;`                   | closes all parenthesis after the cursor -- if there is nothing else |  |  |

#### Notes: ####
  * <sup>1</sup> Not defined to avoid hijacking default vim key bindings.
  * <sup>2</sup> The visual mode mappings do not surround the current marker/placeholder selected, but trigger the INSERT-mode mappings instead.
  * <sup>3</sup> The exact behavior of this mapping has changed with release [r719](https://code.google.com/p/lh-vim/source/detail?r=719). Now, no newline is inserted by default. However, hitting `<cr>` in the middle of a pair of curly-bracket will expand into `{\n<cursor>\n}`.
  * `«»` represents a marker/placeholder, it may be expanded with other characters like `<++>` depending on your preferences.
  * There is no way (yet) to deactivate this feature from the `.vimrc`



### Code snippets ###

#### INSERT-mode snippets abbreviations ####
There exist, over the WWW, a lot of configurations and mappings regarding C programming. Once again you will find shortcuts for `if`, `else`, `elif`  (I know it is not a C keyword, but `else if` are), `for`, `while`, `do`, `switch`, and `main`. In C++, snippets are also provided for `try`, `catch`, and `namespace`.
What is unique is the fact that when you type `if` in insert mode, it will automatically expand into ...
```
if () {
} 
```
... in respect of the context. I.e.: within comments or strings (delimited by single or double quotes) `if` is not expanded. If keyword characters precede the typing, `if` is not expanded as well. Thus variables like `tarif` can be used without getting any headache.


Most of these same snippets, and a few variations, are also provided as template-files for [mu-template](muTemplate.md). This time, you just need to type the first letters of the snippet/template name, and trigger the expansion (with `<c-r><tab>` by default). If several snippets match (like _c/for_, _c/fori_, _cpp/fori_ and _cpp/for-iterator_ when you try to expand `fo`), mu-template will ask you to choose which (matching) snippet you want to expand.

#### Instruction surrounding mappings ####
In visual mode, `,if` wraps the selection within the curly brackets and inserts `if ()` just before. In normal mode `,if` does the same thing under the consideration that the selection is considered to be the current line under the cursor. Actually, it is not `,if` but `<LocalLeader>if,` with `maplocalleader` assigned by default to the coma `,`.

#### Expression-condition surrounding mappings ####
In the same idea, `<LocalLeader><LocalLeader>if` surrounds the selection with `if (` and `) {\n«»\n}«»`.

#### Other notes ####
All the three mode oriented mappings respect and force the indentation regarding the current setting and what was typed.

More precisely, regarding the value of the buffer relative option b:usemarks (_cf._ [map-tools](lhBrackets.md)), `if` could be expanded into:
```
if () {
    «»
}«»
```

### Miscellaneous shortcuts ###
  * `tpl` expands into `template <<cursor>>«»` ;
  * `<m-t>` inserts `typedef`, or `typename` depending on what is before the cursor ;
  * `<m-r>` inserts `return`, and tries to correctly place the semicolon, and a placeholder, depending on what follows the cursor ;
  * `<c-x>be`, `<c-x>rbe` replace `(foo<cursor>)` with `(foo.begin(),foo.end()<cursor>)` (or `rbegin`/`rend`) ;
  * `<c->se`: attempt to fill-in a `switch-case` from an enumerated type ;
  * `,sc` | `,dc` | `,rc` | `,cc` surround the selection with ; `static_cast<<cursor>>(<selection>)`, `dynamic_cast`, `reinterpret_cast`, or `const_cast` ;
  * `,,sc` | `,,dc` | `,,rc` | `,,cc` try to convert the C-cast selected into the C++-cast requested ;
  * `#d` expands into `#define`, `#i` into `#ifdef`, `#e` into `endif`, `#n` into `#include` ;
  * `,0` surrounds the selected lines with `#if 0 ... #endif` ;
  * `pub` expands into `public:\n`, `pro` expands into `protected:\n`, `pri` expands into `private:\n` ;
  * `vir` expands into `virtual` ;
  * `firend` is replaced by `friend` ;
  * `<m-s>` inserts `std::`, `<m-b>` inserts `boost:` ;
  * `?:` expands into `<cursor>? «» : «»;` ;
  * `<C-X>i` will look for the symbol under the cursor (or selected) in the current ctag database and it will try to automatically include the header file where the symbol is defined.

### Templates ###
  * All templates, snippets and wizards respect the naming convention set for the current project -- see my [project style template](https://code.google.com/p/lh-vim/source/browse/mu-template/trunk/after/template/vim/internals/vim-rc-local-cpp-style.template) for an idea of what is supported and possible.
  * stream inserters, stream extractor.
  * bool operator: almost portable hack to provide a boolean operator, strongly inspired by Matthew Wilson's _Imperfect C++_.
  * Generation of [enums](lhCpp_Enums.md), and of switch-case statements from enum definition.
  * constructors: `copy-constructor`, `default-constructor`, `destructor`, `assignment-operator` (see `:h :Constructor`).
  * Various standard types and functions (and a few from boost) have a snippet that'll automatically include the related header file there are are defined. NB: at this time, inclusions are not optimized as IncludeWhatYouUse would optimize them for us. You can have an idea of the snippets provided by browsing [lh-cpp repository here](https://code.google.com/p/lh-vim/source/browse/#svn%2Fcpp%2Ftrunk%2Fafter%2Ftemplate%2Fcpp%253Fstate%253Dclosed).

### Wizards and other high-level features ###
  * [class](lhCpp_Class.md): builds a class skeleton based on the selected (simplified) semantics (value copyable, stack-based non copyable, entity non-copyable, entity clonable)
  * [singleton](lhCpp_Singleton.md): my very own way to define singletons based on my conclusions on this anti-pattern -- you may prefer Loki's or ACE's solutions
  * [:DOX](lhCpp_Doxygen.md): analyses a function signature (parameters, return type, throw specification) and provide a default Doxygenized documentation
  * [:GOTOIMPL](lhCpp_GotoImplementation.md), :MOVETOIMPL: search and jump to a function definition from its declaration, provide a default one in the _ad'hoc_ implementation file if no definition is found
  * [:ADDATTRIBUTE](lhCpp_Accessors.md): old facility that helps define const-correct accessors and mutator, will be reworked. [lh-refactor](lhRefactor.md) provides more ergonomic mappings for this purpose.
  * [:CppDisplayUnmatchedFunctions](lhCpp_UmatchedFunctions.md), `<c-x>u`: shows the list of functions for which there is neither a declaration, nor a definition
  * [:Override](lhCpp_Override.md): Ask which inherited virtual function should be overridden in the current class (feature still in its very early stages)
  * `:Constructor` (that takes the following parameters: `init`, `default`, `copy`, `assign`), or `:ConstructorInit`, `:ConstructorDefault`, `:ConstructorCopy`, `AssignmentOperator`. They'll analyse the list of know attributes (from a ctags database) to generate the related construction functions.

## Syntax highlighting ##
  * assign in condition (bad practice)
  * catch by value (bad practice)
  * throw specifications ([do you really know what they are about, and still want them?](http://www.gotw.ca/gotw/082.htm))
  * function definitions

## Miscellaneous ##
  * home like VC++: mappings that override `<home>` and `<end>` to mimic how these keys behave in VC++.
  * omap-param: defines the o-mappings `,i` and `,a` to select the current parameter (in a list of parameters).
  * a.vim,
  * SiR,
  * lh-cpp imports a [C&C++ Folding plugin](https://github.com/LucHermitte/VimFold4C), which is still experimental.
  * [lh-dev](lhDev.md), which is required by lh-cpp, provides a few commands like `:NameConvert` that permits to change the naming style of a symbol. The possible styles are: `upper_camel_case`, `lower_camel_case`, `snake`/`underscore`, `variable`, `local`, `global`, `member`, `constant`, `static`, `param`, `getter`, `setter`)

## API ##

# Download #
  * Requirements: Vim 7.+, [lh-vim-lib](lhVimLib.md), [lh-map-tools](lhBrackets.md) (take the 1.0.0 beta version from the subversion repository), [mu-template](muTemplate.md), [lh-dev](lhDev.md),
  * With [vim-addon-manager](https://github.com/MarcWeber/vim-addon-manager), install lh-cpp (this is the preferred method because of the [dependencies](http://code.google.com/p/lh-vim/source/browse/cpp/trunk/lh-cpp-addon-info.txt))
  * As a vimball: [here](http://lh-vim.googlecode.com/files/lh-cpp-1.0.0.vba) (not ready yet), or at [Vim.org](http://www.vim.org/scripts/script.php?script_id=336) (old version)
  * Checkout from the SVN repository
```
# Non-members may check out a read-only working copy anonymously over HTTP.
svn checkout http://lh-vim.googlecode.com/svn/cpp/trunk/ lh-cpp-read-only
```

# Credits #

# See also #
  * [C++ tips on vim.wikia](http://vim.wikia.com/wiki/Category:C%2B%2B)
  * c.vim
  * **Project Management**: [local\_vimrc](https://github.com/LucHermitte/local_vimrc)
  * **Compilation**: [BuildToolsWrappers](https://code.google.com/p/lh-vim/wiki/BTW)
  * **Errors Highlighting**: syntastic, [compil-hints](https://code.google.com/p/lh-vim/source/browse/#svn%2Fcompil-hints%2Ftrunk) (a non-dynamic syntastic-lite plugin that'll only highlight errors found after a compilation stage)
  * **CMake Integration**: [lh-cmake](https://github.com/LucHermitte/lh-cmake) + [local\_vimrc](https://github.com/LucHermitte/local_vimrc) + [BuildToolsWrappers](https://code.google.com/p/lh-vim/wiki/BTW)
  * **Refactoring**: refactor.vim, [my generic refactoring plugin](lhRefactor.md)
  * **Code Completion**: [YouCompleteMe](https://github.com/Valloric/YouCompleteMe), really, check this one!, or [OmniCppComplete](http://www.vim.org/scripts/script.php?script_id=1520), or [clang\_complete](https://github.com/Rip-Rip/clang_complete)
  * **Code Indexing**: [clang\_indexer](https://github.com/LucHermitte/clang_indexer) and [vim-clang](https://github.com/LucHermitte/vim-clang), lh-tags