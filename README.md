# Setup Mac OS X

## 1. Software update
Open appstore and make sure Mac OS is up to date.
 
## 2. Dotfiles and scripts
Retrieve dotfiles by cloning git repo:

```
git clone git@github.com:bjrbhre/dotfiles.git
./dotfiles/link.sh
```

**IMPORTANT** This directory is also synced through Dropbox.

**TODO** How should I use rcm?

## 4. Install Softwares

### 4.1 Using laptop.sh

Use [laptop.sh](https://github.com/thoughtbot/laptop) which can run your `~/.laptop.local` if it exists:

```
bash <(curl -s https://raw.githubusercontent.com/thoughtbot/laptop/master/mac) 2>&1 | tee ~/laptop.log
```

### 4.2 From AppStore

+ double pane
+ broom
+ spacie
+ twitter
+ growl


## 3. Settings
**TODO** Script those settings using `defaults write...`

+ install sublimetext package manager see [here](https://sublime.wbond.net/installation)
+ change sublimetext icns [here](http://code.tutsplus.com/tutorials/sublime-text-2-tips-and-tricks-updated--net-21519)
+ iterm mapping for 'option+left/right' [here](https://coderwall.com/p/h6yfda)
+ set name / hostname (in settings)
+ deactivate timemachine
+ configure trackpad
+ configure active corners :
  + TL: mission control
  + BL: application windows
  + TR: notifications
  + BR: desktop
+ finder preferences (barre latérale, chemin d'accès)
+ dock preferences and dock contents
+ deactive guest account
+ account profile picture
+ time format for clock

## 2. SSH Key
Retrieve ssh key or generate a new one:

```
ssh-keygen -f ~/.ssh/id_rsa -N "" # -C "me@example.com"
```
