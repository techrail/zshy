# zshy

Zshy is a small framework that was originally written for a personal workflow. So there is some personal reason to it (described later). It mainly consists of a few goodies that can be useful for writing other scripts and a way to install more scripts. Do not worry - there is no directory or list of extensions and as long as you can access a repository using git, you can install them (including private ones).

## Installation
Clone this repo 

```
git clone https://github.com/techrail/zshy.git
```
Then go to the directory 

```
cd zshy
```
And run the installer:
```
./install.zsh
```

It will copy over all the files and ask you if you want to create the extensions directory or not. It is recommended that you allow it to create the extensions directory.

Upon successful installation, you should have Zshy installed in your `~/.zshy` directory. If you allowed the extensions folder to be created, then you would also find `~/bin/zshy/extensions` and `~/bin/zshy/extensions_data` directories created as well as a `~/bin/zshy/init.zsh` file created. _This file is called every time your shell loads. So you can make modifications to this file instead of your `~/.zshrc` file._

### Updating Zshy 
Go to the directory where zshy was installed 

```
cd ~/.zshy
```
and pull updates via git

```
git pull
```

That should be it!

## Advantages of Zshy
There are a few advantages: 

1. Non-Invasive: It does not change the behavior of the shell. It does not try to modify your `~/.zshrc` file drastically. It does not modify your prompt and just adds one folder to your path. 
2. Gives you functions: There are multiple utility functions that it provides. From printing in color to detecting the OS to doing some string manipulations etc.
3. Allows you to install scripts: So you have a cool script which you have come across. How do you set it up? As long as any repository follows a couple of basic rules (mentioned below), you can just use git to install that script and you can start using it. There is no central plugin list to worry about.
4. Fast: it does not cause bloat. You can add 100 extra extensions to zshy using its extension installation system and they will not bloat the shell. Unless you invoke those extensions, they will not be loaded in the shell when it starts. Everything stays snappy!

## How do I write an extension for Zshy?
Here's how: 

1. Create a folder in the extensions directory (`~/bin/zshy/extensions/`). Assume it is called `myext`; the folder is now placed at `~/bin/zshy/extensions/myext`
2. Create a file named `myext.zsh` in that directory containing your script contents.

That's all it takes. Now if you run `zshy run myext`, it will do a `source ~/bin/zshy/extensions/myext/myext.zsh`, thus executing your script.

You can then put this extension on any git hosted platform. How you structure that script and any other files in it is not zshy's business

**DISCLAIMER**: Shell scripts can contain malicious code that can cause any level of damage to your computer, can be used to steal your data and cause a lot more problems. Please only install a script whose author you can trust or one which you can understand by looking at its source code. Author(s) of Zshy disclaim any responsibility arising from any damages caused by its usage.

## Little History
While I love ohmyzsh and all the goodies, I do not use most of it (except the awesome history navigation features). I like scripts and functions which are descriptive much more than shortcodes/aliases which are not self-explanatory and can cause havoc when you forget what they do. I also do not like remembering really complicated set of command line options, switches, arguments and their orders. I like help along the way. I do not want fancy UI for most of the stuff and would rather prefer to have a guided menu driven interaction; why? Because they do not depend on fancy features being enabled and even a barebones environment like a Docker container should be able to take advantage of scripts that I write.

Zshy thus is a(n extremely) opinionated set of scripts with the above set of behavior (rather 'preferences', really) baked right in. Also, since I already use [powerlevel10k](https://github.com/romkatv/powerlevel10k) and [Oh My ZSH](https://ohmyz.sh/), Zshy is designed to not interfere with functionality of those tools.

### What's with that name?
Honestly, nothing! I just wanted a name which showed that this thing is made for `zsh` and I wanted to save keystrokes typing it. Since the framework stays away from doing a lot and does not try to make any visual or behavioral changes upfront, I named it `zshy`. Not a lot of thought has gone into naming it.

