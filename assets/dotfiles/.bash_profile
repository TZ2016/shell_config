# Tianhao's .bash_profile

export EDITOR=/usr/bin/emacs
export BLOCKSIZE=1k
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export PATH="$PATH:/usr/custom/"

hint () {
  echo 'trash <file> - move file to trash';
  echo 'finder - open current dir in Finder';
  echo 'cdf - cd to dir in the top-most finder, default desktop';
  echo 'findn <pattern> - find filenames matching pattern in current dir';
  echo 'h - show the history from the most recent';
  echo 'hs <pattern> - search history for pattern';
  echo 'hsr <nth> - repeat nth command in history';
  echo '<command> | dump - dump stdout of command to desktop';
  echo 'other shortcuts: ll, .., ~, mcd, c, path, lr, myip, subl, sulast';
  echo 'git commands: switch, conflict, graph';
}

alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias ll='ls -FGlAhp'
alias less='less -FSRXc'
alias ..='cd ../'
alias finder='open -a Finder ./'
alias ~="cd ~"
alias c='clear'
alias path='echo -e ${PATH//:/\\n}'
alias dump='tee ~/Desktop/stdout.txt'
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
alias findn='find . -name '
alias h='history | tail -r | less'
alias hs='history | grep --color=auto'
alias sulast='sudo $(history -p !-1)'
alias myip='curl ip.appspot.com'
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl -w'
alias mongodb='sudo mongod --dbpath ~/workspace/mongodb'

cd() {
  builtin cd "$@"; ll;
}
mcd () {
  mkdir -p "$1" && cd "$1";
}
trash () {
  command mv "$@" ~/.Trash ;
}
hsr() { #redo the command numbered $1 in history
  RG="/^ *$1 */";
  eval $(history | awk "$RG {sub($RG,\"\");print \$0}");
}
cdf () { # 'Cd's to frontmost window of MacOS Finder
  currFolderPath=$( /usr/bin/osascript <<EOT
    tell application "Finder"
        try
    set currFolder to (folder of the front window as alias)
        on error
    set currFolder to (path to desktop folder as alias)
        end try
        POSIX path of currFolder
    end tell
EOT
  )
  echo "cd to \"$currFolderPath\""
  cd "$currFolderPath"
}

extract () {    # Extract most know archives with one command
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)  echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

##
# Your previous /Users/Tianhao/.bash_profile file was backed up as /Users/Tianhao/.bash_profile.macports-saved_2014-08-03_at_14:50:28
##

# MacPorts Installer addition on 2014-08-03_at_14:50:28: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

export PATH=/usr/local/bin:$PATH
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
