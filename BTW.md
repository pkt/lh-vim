# Introduction #

BTW has two main purposes:
  * [To simplify the on-the-fly tuning of `'compiler'` settings.](BTW_filter.md)
  * [To offer a simplified interface to build, execute, test our programs.](BTW_make_run.md)

And it is also able to interface with [projects under CMake](BTW_CMake.md).

# Download #

  * Requirements: Vim 7.+, [lh-vim-lib](lhVimLib.md), [searchInRuntime](searchInRuntime.md), and [system-tools].
  * Checkout from the SVN repository
```
# Non-members may check out a read-only working copy anonymously over HTTP.
svn checkout http://lh-vim.googlecode.com/svn/BTW/trunk/ BTW-read-only
```
  * Vim Addon Manager, install [build-tools-wrapper](http://code.google.com/p/lh-vim/source/browse/BTW/trunk/lh-build-tools-wrapper-addon-info.txt). This is the preferred method because of the various dependencies.

# See also #

## Dependencies ##

You will most certainly require a project management plugin. I can offer you [local\_vimrc](https://github.com/LucHermitte/local_vimrc), there are plenty alternatives (with similar names), or even the good old project.vim plugin.

## Examples of configuration of BTW ##

  * See the two `_local_vimrc*.vim` files from my [Rasende Roboter solver](https://github.com/LucHermitte/Rasende).
  * See the two same files from my configuration for working with openjpeg _(link to be added)_.

## Alternatives ##
There are a few alternative plugins that I'm aware of:
  * [Tim Pope's vim-dispatch](https://github.com/tpope/vim-dispatch) regarding the encapsulation of `:make`
  * Marc Weber's _name-forgotten_ plugin to run things in background
  * [Jacky Alciné's CMake.vim plugin](http://jalcine.github.io/cmake.vim/)