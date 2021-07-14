# Allow SSH tab completion for our aliases hostnames
compdef lisa=ssh
compdef me=ssh
compdef y=ssh
compdef j=ssh
compdef mr=ssh
compdef m=ssh

alias s="ssh -v"
alias m="mosh"
alias kms="mosh --ssh='ssh -l kms'"
alias sa="ssh -v -l admin"
alias a="mosh --ssh='ssh -l admin'"
alias o="mosh --ssh='ssh -l bobby'"
alias lisa="mosh --ssh='ssh -l lisa'"
alias mr="mosh --ssh='ssh -l root'"
alias sr='ssh -v -l root'
alias ru="mosh --ssh='ssh -l root -i ~/.ssh/id_rsa.ubuntu.root'"
alias b="mosh --ssh='ssh -l bobby -i ~/.ssh/id_rsa.ubuntu.bobby'"

alias w1='watch -n 1'
alias w5='watch -n 5'
alias w10='watch -n 10'

# fix ls to be colorized
#alias ls='ls --color=auto'


#mr() {
# h=("${(s/./)1}")
# h=$h[1]
# print -Pn "\e]0;$1\a"
# mosh --ssh='ssh -l root' $1 -- tmux attach -d
#}

#me() {
# h=("${(s/./)1}")
# h=$h[1]
# print -Pn "\e]0;$1\a"
# mosh $1 -- sudo tmux attach -d
#}

#m() {
# h=("${(s/./)1}")
# h=$h[1]
# print -Pn "\e]0;$h\a"
# mosh $1
#}

#y() {
# h=("${(s/./)1}")
# h=$h[1]
# print -Pn "\e]0;$h\a"
# mosh --ssh='ssh -p 26' $1
#}

#j() {
# h=("${(s/./)1}")
# h=$h[1]
# print -Pn "\e]0;$h\a"
# mosh --ssh='ssh -p 26 -l jack' $1
#}


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

# Make short hostname only if its not an IP address
__tm_get_hostname(){
    local HOST="$(echo $* | rev | cut -d ' ' -f 1 | rev)"
    if echo $HOST | grep -P "^([0-9]+\.){3}[0-9]+" -q; then
        echo $HOST
    else
        echo $HOST| cut -d . -f 1
    fi
}

__tm_get_current_window(){
    tmux list-windows| awk -F : '/\(active\)$/{print $1}'
}

# Rename window according to __tm_get_hostname and then restore it after the command
__tm_command() {
    if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=| cut -d : -f 1)" = "tmux" ]; then
        __tm_window=$(__tm_get_current_window)
        # Use current window to change back the setting. If not it will be applied to the active window
        trap "tmux set-window-option -t $__tm_window automatic-rename on 1>/dev/null"
        tmux rename-window "$(__tm_get_hostname $*)"
    fi
    command "$@"
}

ssh() {
    __tm_command ssh "$@"
}

ec2ssh() {
    __tm_command ec2ssh "$@"
}
