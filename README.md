
dotfiles
========

1. `iTerm2`

   * load preferences

2. install `homebrew`

   `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

3. `brew install git ccat`

4. `brew install vim --with-override-system-vi`

5. `brew install zsh antigen autojump`

6. install `shuttle`, `karabiner-elements`, `hammerspoon`

7. optinal installations

   1. install `sdkman`

      `curl -s "https://get.sdkman.io" | bash`

   2. `brew install jenv pyenv sops maven gradle`

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

```
# to see which user is using
ssh -T git@github.com-personal
ssh -T git@github.com

# list all keys
ssh-add -l
# delete all cached keys
ssh-add -D
```



```
# sample ~/.ssh/config

Host github.com
  Hostname ssh.github.com
  Port 443
  User git
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa
  IdentitiesOnly yes

# modify gitconfig to use github.com-personal in the upstream
Host github.com-personal
  Hostname ssh.github.com
  Port 443
  User git
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa_personal
  IdentitiesOnly yes

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa
```



## iTerm2

`General` -> `Preferences`

Check `Load preferences from a custom folder or URL:`

Manually type `~/.dotfiles/iTerm2`



## Antigen & Zsh

``` shell
$ antigen list
# cleanup unused repo (the one not specified in .zshrc)
$ antigen cleanup

$ antigen selfupdate
# update all repos in $(antigen list)
$ antigen update

# reload zsh config
$ exec zsh
```



## Jenv & sdkman

```shell
# 1. install
$ sdk install java 9.0.7-zulu
$ jenv add ~/.sdkman/candidates/java/9.0.7-zulu/

# 2. configure (jenv&sdkman doesn't work well)
$ jenv global 9.0
$ jenv shell 9.0
$ jenv local 9.0
$ sdk default java 8.0.181-zulu

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



## pyenv

### installation

```
# and add eval "$(pyenv init -)" in zsh file
$ brew install pyenv
```

### details

```shell
# system-installed python
$ ls -al /usr/bin/python*

# brew-installed python
$ ls -al /usr/local/bin/python*

# pyenv-installed python
$ ls -alFh ~/.pyenv/versions/
```

* macos install python @`/System/Library/Frameworks/Python.framework` -> ` /usr/bin/`
* brew install python @`/Cellar/python` -> `/usr/local/bin/`
* `pyenv` install python @`~/.pyenv/versions/`

### usage

```
➜  ~ pyenv versions
  system
* 3.6.9 (set by /Users/foo/.pyenv/version)
  3.8.0
➜  ~ pyenv global 3.8.0
➜  ~ pyenv shell 3.8.0
➜  ~ pyenv which python
/Users/foo/.pyenv/versions/3.8.0/bin/python
➜  ~ python --version
Python 3.8.0
➜  ~ which python
/Users/foo/.pyenv/shims/python
```



```
# disable specific shell version in order to activate the version specified in .python-version
$ pyenv shell --unset
```



which python is used?

1. pyenv shell
2. pyenv local
3. pyenv global
4. python in the `$PATH` (system or brew-installed one)



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

Homebrew installs packages to their own directory and then symlinks their files into `/usr/local`.
```
$ cd /usr/local
$ find Cellar
Cellar/wget/1.16.1
Cellar/wget/1.16.1/bin/wget
Cellar/wget/1.16.1/share/man/man1/wget.1

$ ls -l bin
bin/wget -> ../Cellar/wget/1.16.1/bin/wget
```

```
$ echo $(brew --prefix)
/usr/local
```



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
