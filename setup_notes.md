# nvim setup notes
The goal of these notes are to:
* Make my setup reproducible
* Keep track of what I learn about nvim hacking because my memory is leaky

# Setup by topic/language
## Initial installation
### MacOS
Generally following (nvim's kickstart)[https://github.com/nvim-lua/kickstart.nvim]. Original notes in (evernote)[https://share.evernote.com/note/4b7fef71-7e33-b155-a7f2-47764c5368ca]
* `brew install neovim`
* Native git
* Probably using native make
* Native unzip
* Existing installation of gcc from Apple command line dev tools
* `brew install ripgrep`
* `brew install fd`
* Clipboard command line tool for MacOS is pbcopy... I remember testing that it worked, but I'm not sure if I did anything to configure it
* Nerd font -- I looked at it, but wasn't sure how to do a full installation and decided to skip it for now; have installed nvim assuming no nerd font
* Lastly I forked [nvim kickstart git repo](https://github.com/nvim-lua/kickstart.nvim) into my [personal github](https://github.com/mr-calvert/nvim-config). [details in](#ssh-token-setup)
#### ssh token setup
- Setup an ssh key for this machine: `ssh-keygen -t ed25519 -C "scalvert@onepost.net"`
- I set a passphrase 
- Setup ~/.ssh/config to auto-load the key into MacOS's built-in ssh-agent per github instructions
- Added the key to the running ssh-agent and setup the passphrase in the apple keychain.
- Forked nvim-lua/kickstart.nvim into my own github and cloned that into ~/.config/nvim

# go-lang setup
* `brew install go` on personal laptop
* TODO: d/l a go-lang repo
* TODO: activate tree-sitter and confirm what I should expect for it (does it support anything with telescope)
* TODO: install/activate go's lsp, plumb the depths of what it enables, especially interaction with telescope, refactorings, compile errors in quickfix?
* TODO: explore, and get baseline config for test execution integration, esp with quickfix (or trouble?) jump to failures
* TODO: configure easy go fmt, lint, any other tools?
* TODO: integrate debugger

# Setup effort notes by date
## 2025-11-19
### Spelling
Followed the directions [from reddit](https://www.reddit.com/r/neovim/comments/1fwqc8t/how_to_enable_spell_check_for_only_specific_files/). Exited nvim and restarted, but it didn't seem to take effect. I learned about `:.lua` to run THIS line and `:lua [lua code here]` and ran `:lua vim.opt.spell=true` which seems to impact only the current buffer? Anyway, that's why these notes aren't cripplingly misspelled.

### Line wrapping
`vim.opt.wrap` flag en/disables soft line wrapping. Was on by default. `vim.opt.linebreak` flags if the soft wrapping should be at word boundaries. This was off. When I figure out how to control things by file type I'll want to make sure files with prose have both turned on.

### 2025-11-26
* Removed previous manual installation of zig and zls
* Looking into version managers. There are a couple specific to zig, found `zigenv` and `zvm`, but both are zig specific and this is a common enough problem I'm hoping to just have one tool. Decided that I don't need that right now and am just going to use homebrew. Done.
* I figured out why conditional spell checking wasn't working... I was setting `vim.opt_local.spell=false` when I meant true. 
* Was about to start configuring zig tooling but I decided I'd rather use the modularized version of kickstart, one big file is a sad choice. Switching to the modular one is the next thing to do. Then setup zig tooling.

### 2025-11-27
* Nuked the old repository, forked again from (modular kickstart repo)[https://github.com/dam9000/kickstart-modular.nvim], and moved my notes, cheat sheet, and spelling config over.
* Installed go with homebrew
* Was struggling with todo comments, they just didn't seem to work when I typed things. I was typing "TODO" but it turns out that there has to be a trailing colon, so "TODO:" not "TODO".
* I got thrown for a loop, wanted to do a live grep but I couldn't find it in the menu of options when I did "[leader]s" while editing this file. But then it was there when I was editing lua. I did find "[leader]sg" was live grep and I tried it inside this file and it worked. Not sure what's up.
