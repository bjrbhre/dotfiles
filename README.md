# Dotfiles

## System Setup

### 1. install.sh

`install.sh` script helps setting up a new system from scratch.
Dowload and execute:

```
curl --remote-name https://raw.githubusercontent.com/bjrbhre/dotfiles/master/install.sh
vi install.sh
bash install.sh
```

What is does:

1. update system software
2. clone and link dotfiles (entire repo)
3. install sofware using [laptop.sh](https://github.com/thoughtbot/laptop)
4. create ssh key

### 2. Binaries & Applications install

Laptop script will run commands listed in `~/.laptop.local`.
Edit its content to fit your requirements.

Typically, `.laptop.local` will install:
- brew binaries using `brew install ...`
- brew cask apps using `brew cask install ...`
- Mac AppStore apps using `mas install ...`

### 3. Settings

Currently, additional settings are done manually (e.g. configure MacOS preferences).
See file `preferences/README.md`.

