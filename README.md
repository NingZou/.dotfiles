
dotfiles
========

1. `iTerm2`
   * load preferences

2. install `homebrew`

   `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

3. `brew install git jenv ccat vim`

4. `brew install zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting autojump`

   1. maybe `rm -f ~/.zcompdump; compinit` is needed. [link](https://github.com/Homebrew/homebrew-core/blob/master/Formula/zsh-completions.rb#L20)

5. install `shuttle`, `karabiner-elements`, `hammerspoon`

6. instal `sdkman`

   `curl -s "https://get.sdkman.io" | bash`

7. install `oh-my-zsh`

   `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`

8. run script `./up.sh` to install **configs** for

   * `bash`
   * `editorConfig`
   * `git`
   * `hammerspoon`
   * `karabiner-elements`
   * `shuttle`
   * `tmux`
   * other configurations included in `app_configs` file
     * `jenv`
     * `sdkman`

9. modify `~/work/gitconfig-work` file

10. other usefull apps:

   * `Visual Studio Code`
     * install `editorConfig` plugin
   * `sdk install gradle`
   * `sdk install maven`

## hammerspoon

```
# list all running applications
for key,value in pairs(hs.application.runningApplications()) do print(key,value) end
```

## Git

```
# root .gitconfig
[includeIf "gitdir:~/work/"]
    path = ~/work/gitconfig-work
```

## iTerm2

`General` -> `Preferences`

Check `Load preferences from a custom folder or URL:`

Manually type `~/.dotfiles/iTerm2`

## Jenv & sdkman

```shell
# 1. install
$ sdk install java 9.0.7-zulu
$ jenv add ~/.sdkman/candidates/java/9.0.7-zulu/

# 2. configure
$ jenv global 1.9
$ jenv shell 1.9
$ jenv local 1.9

# 3. check
$ jenv versions
```

### Jenv

```shell
brew install jenv
echo 'eval "$(jenv init -)"' >> ~/.bashrc

# not need to do the following, since brew install jenv under /usr/local/bin
# echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bashrc
```
```
# list all JAVA_HOMEs configured in jenv
ls -alF ~/.jenv/versions
```

#### enable jenv for maven
```shell
# run maven with a specific jdk
$ jenv local 1.7
$ jenv enable-plugin maven

# re-enable maven plugin if maven is using Java with a wrong version
$ jenv disable-plugin maven

# this could also affect maven since maven could be used in terminal
$ jenv shell 1.8

# double-check to see which java version maven is using
$ mvn -version
```

#### java locations

* `sdkman` install java at: `~/.sdkman/candidates/java/`

  `jenv add ~/.sdkman/candidates/java/8u161-oracle/`

* system default location: `/System/Library/Frameworks/JavaVM.framework/Versions/`

* java in System Perferences location: `/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/`



## rbenv

```
rbenv versions
rbenv global 2.2.3
# shell has be specified for each new session, otherwise it will use a default one
rbenv shell 2.2.3
```

## Homebrew

### usages
[FAQ](http://docs.brew.sh/FAQ.html)

```
# update homebrew itself
brew update

# upgrade everything
brew upgrade

# version
brew outdated
brew pin activemq
brew unpin activemq
brew list --pinned

# cleanup & uninstall
brew cleanup git
brew uninstall git
brew uninstall --force git
## list what would be cleaned up
brew cleanup -n
brew cleanup

# figure out who is using a specific formula
brew uses --installed stranger_formula

# list all dependencies
brew deps --installed
```

### details

1. homebrew install apps @ `/usr/local/Cellar/`
2. create corresponding link @ `/usr/local/bin/`

Thus, homebrew will  set `/etc/paths` to

	/usr/local/bin
	/usr/bin
	/bin
	/usr/sbin
	/sbin

Put `/usr/local/bin` at the first line.

Or go to shell configuration and add `/usr/local/bin` to `$PATH`.

Restart terminal and test it

	$ which git
	/usr/local/bin/git

In this way, I may not need to explicitly specify command home location for `JAVA_HOME` or `MAVEN_HOME` in `.bashrc`. It will automatically use the default one, i,e, the first line in `/etc/paths`.

## Homebrew Cask

applications are installed at `/usr/local/Caskroom`, each application could have multiple versions

```
# find out outdated installed versions
brew cask outdated
```

Probably need to manually delete old versions.



## MacOS

```
$ defaults write com.apple.screencapture location $HOME/documents
$ killall SystemUIServer

$ defaults read .GlobalPreferences com.apple.mouse.scaling
3
$ defaults read .GlobalPreferences com.apple.trackpad.scaling
1.5
```
