# dotfiles

my shell configs
- zshrc
- dotfiles
- dev tools setup

## test with docker

```sh
docker run --rm -it debian -c "apt update && apt -y install curl && curl -sL https://raw.githubusercontent.com/warbaque/dotfiles/refs/heads/main/setup/shell | sh -s -- no-gui && TERM=xterm-256color /bin/zsh"
```

## quick setup (apt & curl)

```sh
# minimal
curl -sL https://raw.githubusercontent.com/warbaque/dotfiles/refs/heads/main/setup/shell | sh -s -- minimal

# full
curl -sL https://raw.githubusercontent.com/warbaque/dotfiles/refs/heads/main/setup/shell | sh -s -- full && /bin/zsh

# no-gui
curl -sL https://raw.githubusercontent.com/warbaque/dotfiles/refs/heads/main/setup/shell | sh -s -- no-gui && /bin/zsh
```

## helper / tool installer
```
❯ helper
usage:
  setup/shell <cmd> [<args>]

Available commands:

[install core packages]
  minimal             minimal setup (zsh, dotfiles)
  extra               extra packages
  gui                 gui packages
  full {--no-gui}     install all
  no-gui              full --no-gui

[setup]
  tools {category}    setup tools
  dotfiles {dotfile}  setup dotfiles
  sudoers             setup sudoers

```

## zshrc-extras

enable/disable project specific zshrc configs
```
❯ zshrc-extras
usage: zshrc-extras <cmd> [<args>...]

  enable <file>       enable config (alias: add)
  enable-all          enable all configs
  disable <file>      disable config (aliases: del rm)
  disable-all         disable all configs (alias: reset)
  <cmd> <file>        open {file} with {cmd}

  load <file>         load available <file>
  reload              load all enabled files
```

## example

![example](example.gif)
