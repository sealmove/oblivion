# oblivion
Shell command manager

## Motivation
Shell commands are complex. Each executable has its own interface, and often multiple of these are used in one command. At some point you reach out to a notebook/notepad for writing down this perfectly crafted pipeline with tons of options for each program. Later you find yourself reaching out to that memo too often, and still struggle to memorize it, so you end up making a shell alias for it. As this situation goes on, your shell starts getting cluttered and the aliases start conflicting with one another; so you decide to group commands by theme, functionality or whatever, and come up with a pseudo-namespaces for each group (i.e. prefix each alias related to package management with "pm").

You can think of oblivion as something that helps you define proper alias interfaces.

## Installation
``` bash
curl https://nim-lang.org/choosenim/init.sh -sSf | sh # install Nim
git clone https://github.com/sealmove/oblivion.git
cd oblivion
nimble install
```

_Soon the project will be published to nimble's list, so you won't need to clone it manually._

## Usage
All you need a file called `config.ini` in `$XDG_CONFIG_DIRS` (which by the way needs to be set) where you put your commands.  
This file follows an extended ini format according to Nim's [parsecfg module](https://nim-lang.org/docs/parsecfg.html).

By default, when you install oblivion through nimble, the executable is named `o`.  
You can run it with 0 or more arguments:
| # of args | functionality |
|-----------|-----------------------------------------------------|
| 0         | prints the defined interfaces                       |
| 1         | prints the commands in argument's interface         |
| 2         | runs a command in an interface                      |
| 2+`x`     | runs a command and supplies the `x` arguments to it |

If you need parameters for your command, you can specify them as `$1`, `$2`, etc.  
Oblivion will verify that the # of arguments you provided matches the # of parameters in the command, and then perform substitution.  
You don't have to type out the full name of the interface or command, as long as that's not ambiguous.

## Example

`/etc/xdg/oblivion/config.ini`
``` ini
[package]
list   = "eix -c --world"
flags  = "equery u $1"
conf   = "sudo dispatch-conf"
emerge = "sudo emerge --ask $1"
sync   = "sudo eix-sync"
update = "sudo emerge -uDU --ask --with-bdeps=y @world"
unmask = "sudo emerge --ask --autounmask=y --autounmask-write $1"

[configure]
alias    = "nvim /usr/share/oh-my-zsh/custom/aliases.zsh"
i3       = "nvim /home/sealmove/.config/i3/config"
nvim     = "nvim /etc/xdg/nvim/sysinit.vim"
zsh      = "nvim /usr/share/oh-my-zsh/zshrc"
oblivion = "sudo nvim /etc/xdg/oblivion/config.ini"

[net]
myip = "dig +short myip.opendns.com @resolver1.opendns.com"
```

``` bash
$ o p l
= eix -c --world # the command is printed and run
```
