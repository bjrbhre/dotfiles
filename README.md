# Dotfiles

## System Setup

### 1. install.sh

`install.sh` script helps setting up a new system from scratch.
Dowload and execute:

```
curl -s https://raw.githubusercontent.com/bjrbhre/dotfiles/master/install.sh | sh
```

TODO use token for private repo access (see [here](https://gist.github.com/Integralist/9482061))

What is does:

1. update system software
2. clone and link dotfiles (entire repo)
3. install sofware using [laptop.sh](https://github.com/thoughtbot/laptop)
4. create ssh key

### 2. AppStore

Following apps can only be downloaded through Mac AppStore:

+ double pane
+ broom
+ spacie
+ twitter
+ growl


### 3. Settings

Following settings must be set manually:

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

## TODO

+ Script settings using `defaults write...`
+ Use rcm to manage dotfiles?
+ Fix config.env when rbenv not installed
