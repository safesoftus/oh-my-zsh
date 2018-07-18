# Allow SSH tab completion for our aliases hostnames
compdef lisa=ssh
compdef me=ssh
compdef y=ssh
compdef j=ssh
compdef mr=ssh
compdef m=ssh

alias s="ssh -v"
alias sr='ssh -v -l root'

# fix ls to be colorized
alias ls='ls --color=auto'

# mosh aliases
lisa() {
 h=("${(s/./)1}")
 h=$h[1]
 print -Pn "\e]0;$h\a"
 mosh --ssh='ssh -l lisa' $1 -- sudo tmux attach -d
}

mr() {
 h=("${(s/./)1}")
 h=$h[1]
 print -Pn "\e]0;$1\a"
 mosh --ssh='ssh -l root' $1 -- tmux attach -d
}

me() {
 h=("${(s/./)1}")
 h=$h[1]
 print -Pn "\e]0;$1\a"
 mosh $1 -- sudo tmux attach -d
}

m() {
 h=("${(s/./)1}")
 h=$h[1]
 print -Pn "\e]0;$h\a"
 mosh $1
}

y() {
 h=("${(s/./)1}")
 h=$h[1]
 print -Pn "\e]0;$h\a"
 mosh --ssh='ssh -p 26' $1
}

j() {
 h=("${(s/./)1}")
 h=$h[1]
 print -Pn "\e]0;$h\a"
 mosh --ssh='ssh -p 26 -l jack' $1
}


# List the most recent files in a directory
lsnew()
{
        ls -lt ${1+"$@"} | head -20;
}

# Make directory and cd inside it
function mkcd {
    mkdir -p "$*"
    cd "$*"
}

# Random password generation function
function genpasswd {
  local l=25 # default password lenght
  if [ "$#" != "0" -a "$1" -gt 0 ]
  then
    l=$1
  fi
  tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}
