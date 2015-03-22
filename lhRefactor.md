# Features #

lh-refactor is a generic refactoring plugin.

So far it supports the following refactorings (v0.2.2):
  * Extract Function,
  * Extract Variable,
  * Extract Type,
  * Extract Getter & Extract Setter, _(it's more a generate than an extract actually)_
and the following languages: C, C++, Java, Pascal, VimL.

The list of languages supported can be extended (however some refactoring work in the plugin is required to simplify that part)

The complete documentation can be browsed [in the subversion repository](http://code.google.com/p/lh-vim/source/browse/refactor/trunk/doc/refactor.txt)

# Mappings #
### Visual-mode Mappings ###
  * `<C-X>f` to eXtract a Function
  * `<C-X>v` to eXtract a Variable
  * `<C-X>t` to eXtract a Type
### Normal-mode Mappings ###
  * `<C-X>g` to eXtract a Getter, and `<C-X>s` to eXtract a Setter
  * `<C-X>p` and `<C-X>P` to Put back the definition that as been extracted

# Download #
  * Requirements: Vim 7.1, [lh-vim-lib](lhVimLib.md), my [bracketing system](lhBrackets.md), [lh-dev](http://lh-vim.googlecode.com/svn/dev/trunk/) (and thus [lh-tags](http://code.google.com/p/lh-vim/source/browse/tags/trunk/), ...)
  * With [vim-addon-manager](https://github.com/MarcWeber/vim-addon-manager), install `lh-refactor` (this is the preferred method because of the [dependencies](http://code.google.com/p/lh-vim/source/browse/refactor/trunk/lh-refactor-addon-info.txt))
  * ~~As a vimball: [here (v0.1.0)](http://lh-vim.googlecode.com/files/lh-refactor-0.1.0.vba)~~
  * Checkout from the SVN repository
```
# Non-members may check out a read-only working copy anonymously over HTTP.
svn checkout http://lh-vim.googlecode.com/svn/refactor/trunk/ lh-refactor-read-only
```

# See also #
  * Klaus Horsten's tip: [Vim as refactoring tool (with examples in C#)](http://vim.wikia.com/wiki/Vim_as_a_refactoring_tool_and_some_examples_in_C_sharp)
  * [lh-cpp](lhCpp.md) defines a few other refactoring-like functionalities:
    * Generate accessor and mutator (`:ADDATTRIBUTE`),
    * Generate default body given a function signature (`:GOTOIMPL`)
  * [Refactoring.com](http://www.refactoring.com/catalog/index.html)