# Setting Preferences

Currently, some settings (e.g. MacOS preferences) are set manually.

## Automate ?

+ Script settings using `defaults write...`
+ Use rcm to manage dotfiles?
+ Fix config.env when rbenv not installed

## Finialize installation
- [ ] Sync Dropbox folder to `~/Documents/Dropbox`
- [ ] Remove `~/.dotfiles` folder and replace it with a symlink `ln -s ~/Documents/Dropbox/dotfiles ~/.dotfiles`
- [ ] Setup 1Password / Sync Dropbox vault
- [ ] Open Chrome and Connect
- [ ] Add ssh key to github
- [ ] Setup DoublePane and change preferences (start at login / do not show in menu bar)
- [ ] Setup Alfred: Appearance > Options > Hide hat and Hide menu bar icon"
- [ ] Setup Caffeine
- [ ] Setup iStats (key synced in 1Password)
- [ ] Load iTerm2 preferences from file
- [ ] Sync SublimeText preferences `ln -s ~/.dotfiles/preferences/sublime/Preferences.sublime-settings ~/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings`
- [ ] Install SublimeText package manager see [here](https://sublime.wbond.net/installation) and install
  - [ ] Better CoffeeScript
  - [ ] Dockerfile Syntax Highlighting
  - [ ] Saas

Mac OS Preferences:
- [ ] Keyboard Shortcurts
  - [ ] Remove Mission control / Application Windows / Show spotlight search
- [ ] Display preferences
 - [ ] unselect "show mirroring options..."
 - [ ] Night shift
- [ ] Never start screen saver
- [ ] Dock: small / left / automatically hide
- [ ] Remove Dock content
  - `defaults delete com.apple.dock persistent-apps
     defaults delete com.apple.dock persistent-others
     killall Dock`
- [ ] Configure active corners :
  - TL: mission control
  - BL: application windows
  - TR: notifications
  - BR: desktop
- [ ] Security & Privacy > General > Require password immediately
- [ ] Keyboard:
  - add dvorak layout `sudo cp -R ~/.dotfiles/preferences/fr-dvorak-bepo.bundle /Library/Keyboard Layouts`
  - add layout and set keyboard shortcut
- [ ] Trackpad preferences
- [ ] iCloud: remove photos / mail / contacts / calendrier / rappels / etc.
- [ ] Add internet accounts (gmail)
- [ ] User & Groups > Login options > Show input menu in login window
- [ ] Sharing > Set hostname
- [ ] Menu Bar:
  - [ ] Show battery percentage
  - [ ] Configure clock

Finder Preferences:
- [ ] New Finder show "my folder"
- [ ] Set sidebar content
- [ ] Advanced > Show all filename extensions
- [ ] Rearrange sidebar items
- [ ] View > Show status bar & path bar

Misc:
- [ ] Install [adobe-fonts/source-code-pro](https://github.com/adobe-fonts/source-code-pro)
