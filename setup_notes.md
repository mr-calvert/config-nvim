# nvim setup notes
The goal of these notes are to:
* Make my setup reproducible
* Keep track of what I learn about nvim hacking because my memory is leaky

## Philosophy of external tool management
Initially at least I've taken the attitude that I don't want my editor (vscode, jetbrains, nvim, whatever) to own my language tooling; I'd like all that stuff to be on standard paths and work on the command line as a peer to the IDE/editor. The exception is language servers. Those are tied tightly enough to the editor/IDE I'm fine having the editor manage it.

Currently I'm leaning on homebrew on Macs for tooling management. We'll see how that goes. *rust* is managed via rustup
installed fully manually on MacOS. Would be interesting to see how best to do it for automatic vworkstation
configuration.

## Squawk Sheet
* gotestsum didn't download/install -- replaced with `brew install gotestsum`
* rust-analyzer seems to require a save to update the parse, others didn't. Not sure why, but it's slightly annoying

# TODO configurations, research, languages, puzzles
* Configure nvim with a keymap to close a buffer without killing the window it's in to keep my window configuration
* Autosave?
* Give some love to the key bindings. I like [leader][functional area][specific function] as a pattern. Testing under
  [leader]t is ok, but there's a bunch of cruft rn. [leader]s is good. gr? for LSP stuff makes no sense.
* Setup zig source level debugging via codelldb. codelldb is a vscode extension, you need to install vscode then the
  extension, then grab it from vscode's private internals. See (old but comprehensive blog
  post)[https://eliasdorneles.com/til/posts/customizing-neovim-debugging-highlight-zig-debug-w-codelldb/] on the topic.
* Folding configuration esp driven by treesitter
* cpp
* python
* `delve` = go-lang debugger is currently installed via mason in `~/.config/nvim/lua/kickstart/plugins/debug.lua`, try
  to remove it and install via homebrew

# Setup by topic/language
## Initial installation
### MacOS
Generally following (nvim's kickstart)[https://github.com/nvim-lua/kickstart.nvim]. Original notes in (evernote)[https://share.evernote.com/note/4b7fef71-7e33-b155-a7f2-47764c5368ca]
* `brew install neovim`
* Native git
* Native make
* Native unzip
* Existing installation of gcc from Apple command line dev tools
* `brew install ripgrep`
* `brew install fd`
Symlink Clipboard command line tool for MacOS is pbcopy... I remember testing that it worked, but I'm not sure if I did anything to configure it
* Nerd font -- Considered but wasn't sure how to do a full installation and decided to skip it for now; have installed nvim assuming no nerd font
* Setup ssh key if it doesn't exist: `ssh-keygen -t ed25519 -C "scalvert@onepost.net"` [details in](#ssh-token-setup) -- replace email as appropriate
* Clone [personal nvim repo](https://github.com/mr-calvert/nvim-config) into `~/.config/nvim`. Personal repo is a clone of (modularized kickstart)[https://github.com/dam9000/kickstart-modular.nvim]
* Symlink `.editorconfig` from the root of the nvim directory up to `~/.config` so it rules over all .dotfiles. Symlink to `~/code` so it rules by default over all repos.

#### ssh token setup
- I set a passphrase
- Setup ~/.ssh/config to auto-load the key into MacOS's built-in ssh-agent per (github instructions)[https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent]
- Added the key to the running ssh-agent and setup the passphrase in the apple keychain.

## go-lang setup
* `brew install go` on personal laptop
* Leaving GOPATH and GOROOT unset right now because that's how homebrew left it. The GOPATH default is ~/go which is fine for me, curious if that will cause problems with tooling.
* TODO: configure easy go fmt, lint, any other tools?
* TODO: plumb the depths of gopls support, especially interaction with telescope, refactorings, compile errors in quickfix?

## zig setup
* `brew install zig zls`
* `brew install tree-sitter-cli` -- zig's treesitter grammar isn't precompiled
* In nvim `:TSInstall zig`

## rust setup
* (*USE RUSTUP*)[https://rust-lang.org/tools/install/] -- this page pipes curl output to `sh`. No. Write it to disk,
  read it, then run it. Bloody hell do they think we were born yesterday??
* :TSInstall rust


# Setup effort notes by date
## 2025-11-30
### Rust setup
* Discovered I have rustup already installed (no surprise really). For rust rustup is the way to go.
* Manual installation of rust treesitter
* Just uncommented the example in `~/.config/nvim/lua/kickstart/plugins/lspconfig.lua`. rust-analyzer immediately kicked
  in, but it doesn't run on code edits, just on :w. Seems reasonable since it's expensive, but I'll want to see about
  configuring that (added a squawk), or pairing with autosave, that I probably want anyway.
* Just like zig, since rust is an llvm language it uses codelldb as a DAP adapter for lldb. Still looks like I'll have
  to lean on VSCode to install it and then link to the binary. Not sure how I'll do that on vworkstation though.

### Zig setup
* Timeboxed source level debugging, added as a separate todo because it involves stealing a DAP adapter from VSCode.

## 2025-11-29
### Setup Zig support
* Personal laptop already has zig and zls installed via homebrew
* Looking into the new version of nvim-treesitter, the new version's setup is a lot different. I tried to adjust to the
  new setup stuff, but no I couldn't get it to even attempt to install zig. Not sure if I'm not getting the Lazy stuff
  right, or if the nvim-treesitter stuff is wrong. So I tried :TSInstall zig, and that failed. It seems for zig we need
  to build the grammar, but treesitter cli is not installed.
* Couldn't figure out how to get treesitter to auto install parsers from the configuration. I'm curious what it does on
  a new installation. Timeboxing this effort and just planning on :TSInstall zig
* Setup zls (zig language server) in lspconfig, worked right away.

### Continue focus on go-lang setup
* Created .editorconfig and enabled Editorconfig support in nvim. Intention is to have it setup in dotfiles when I get around to that part of my setup.
* neotest configuration can definitely go to insane depths: (neotest author's go-lang configs)[https://fredrikaverpil.github.io/neotest-golang/recipes/#per-project-configuration]
* neotest-golang asks to be run against the `main` branch of nvim-treesitter. Google's AI seems to think that
nvim-kickstart uses `main`, but when I checked the cloned repo at `~/.local/share/nvim/lazy/nvim-treesitter/` it looks
like `master` is checked out.
* Stopped and restarted vim and there was no sign of Lazy picking up the changes. So I ran :Lazy sync and it did a whole
  lot of updates (oops?). The only change I noticed in :checkhealth before vs after was that the support matrix for
  loaded languages for nvim-treesitter was empty post :Lazy sync. But vim-treesitter listed all the loaded plugins.
  Syntax highlighting still works, but maybe when I enable others they'll not work? Maybe loading new parsers won't
  work? The nvim-treesitter repo checked out in `~/.local/share/nvim/lazy/nvim-treesitter/` is detached HEAD, making me
  think it merged master and main. Considering checking out main and restarting nvim, feels iffy. Post :Lazy sync
  there's a runtime error when I open a path with backtick. This used to supply tab completion vs filesystem, now it
  breaks.
* Confirmed that LSP works for go-hello and DAP can step through prod side, tests obviously not.
* First pass at neotest setup with nvim-neotest-go and gotestsum. There was an error related to nvim-treesitter.configs,
  and it doesn't seem like gotestsum was found, maybe not installed.

## 2025-11-28 -- Focus on go-lang setup
* A bit of research into nvim roadmap. Builtin lsp integration is coming in 0.12.x, but stable is 11.5.x, so the kickstart lsp stuff is still fully relevant.
* Added go to lua/kickstart/plugins/treesitter.lua, played around with treesitter integration using fzf go source code. Need to come back to learn about folds and indenting features
* Added gopls to `local servers` in `lspconfig.lua` and it just worked. There are some keybindings for LSP that are mostly off `gr`
* Enabled DAP (debugger access protocol) by uncommenting the line enabling debug.lua. I wasn't able to get it running against fzf, but I built a hello world and the debugger worked. Lots to learn about DAP.
* Looking for help running tests, DAP has support for debugging a test (which I haven't made work yet), but the real deal seems to be [neotest](https://github.com/nvim-neotest/neotest).

## 2025-11-27
* Nuked the old repository, forked again from (modular kickstart repo)[https://github.com/dam9000/kickstart-modular.nvim], and moved my notes, cheat sheet, and spelling config over.
* Installed go with homebrew
* Was struggling with todo comments, they just didn't seem to work when I typed things. I was typing "TODO" but it turns out that there has to be a trailing colon, so "TODO:" not "TODO".
* I got thrown for a loop, wanted to do a live grep but I couldn't find it in the menu of options when I did "[leader]s" while editing this file. But then it was there when I was editing lua. I did find "[leader]sg" was live grep and I tried it inside this file and it worked. Not sure what's up.

## 2025-11-26
* Removed previous manual installation of zig and zls
* Looking into version managers. There are a couple specific to zig, found `zigenv` and `zvm`, but both are zig specific and this is a common enough problem I'm hoping to just have one tool. Decided that I don't need that right now and am just going to use homebrew. Done.
* I figured out why conditional spell checking wasn't working... I was setting `vim.opt_local.spell=false` when I meant true.
* Was about to start configuring zig tooling but I decided I'd rather use the modularized version of kickstart, one big file is a sad choice. Switching to the modular one is the next thing to do. Then setup zig tooling.

## 2025-11-19
### Spelling
Followed the directions [from reddit](https://www.reddit.com/r/neovim/comments/1fwqc8t/how_to_enable_spell_check_for_only_specific_files/). Exited nvim and restarted, but it didn't seem to take effect. I learned about `:.lua` to run THIS line and `:lua [lua code here]` and ran `:lua vim.opt.spell=true` which seems to impact only the current buffer? Anyway, that's why these notes aren't cripplingly misspelled.

### Line wrapping
`vim.opt.wrap` flag en/disables soft line wrapping. Was on by default. `vim.opt.linebreak` flags if the soft wrapping should be at word boundaries. This was off. When I figure out how to control things by file type I'll want to make sure files with prose have both turned on.

