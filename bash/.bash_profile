export PATH=/mingw64/bin:/bin:/usr/bin:/usr/bin/vendor_perl:/usr/bin/core_perl

export PS1='[\t \W] $ '
export LESS="$LESS -i -R -X -F"

export JAVA_HOME='c:/Program Files/Java/jdk1.8.0_231/'
mvn='/c/Users/mle10/home/programs/apache-maven-3.6.1/bin/mvn'

#/********************************************************************************
# * Options
# ********************************************************************************/

shopt -s histverify histreedit globstar
stty -ixon

#/********************************************************************************
# * Alias
# ********************************************************************************/

alias h=history
alias l='ls -lAF'
alias ll='ls -al --color | less -R'
alias pd='pushd .'
alias ph='dirs -p'

#/********************************************************************************
# * Git
# */

gitCmdLogger() {
    local cmd="command git $*"
    if echo $cmd | egrep '(fetch)|(merge)|(push)|(pull)' &> /dev/null; then
        if local logDir=`command git rev-parse --git-dir 2> /dev/null`/logs; then
            if [ -w "$logDir" ]; then 
                local logfile=$logDir/git.log
                echo "--- `date` - $cmd" >> $logfile
                eval $cmd 2>&1 | tee -a $logfile
            else
                eval $cmd
            fi
        else
            eval $cmd
        fi
    else
        eval $cmd
    fi
}

git() {
    gitCmdLogger "$@"
}

alias g=git
alias ga='g add'
alias gb='g rev-parse --abbrev-ref @'
alias gbt='g branch --sort=-committerdate'
alias gci='g commit'
alias gco='g checkout'
alias gco-='g checkout @{-1}'
alias gd='g diff'
alias gdir='git rev-parse --git-dir'
alias gf='g fetch'
alias gl='g log --graph --name-status --abbrev-commit'
alias glo='g log --graph --abbrev-commit --oneline'
alias go='g config --get remote.origin.url'
alias gr='g reflog --date=iso'
alias gs='g status -s --untracked-files=no'
alias gsu='g status -s --ignored=no'
alias gsh='g show'
alias gst='g stash list'

gm() {
    local gitDir=`gdir` && grep -Hn . $gitDir/MERGE* $gitDir/REBASE* 2>/dev/null
}

gbtt() {
    gbt --format="'%(if)%(HEAD)%(then)%(HEAD)}%(color:green)%(else) }%(end)%(refname:short)%(color:magenta)|%(committerdate:iso)|%(color:yellow)%(objectname:short)|%(color:white)%(subject)' $@ --color=always | column -ts'|'"
}

#/********************************************************************************
# * Functions 
# ********************************************************************************/

cdHistoryFile=~/.bash_cdhistory
cd() {
    builtin cd "$@" && echo $PWD >> $cdHistoryFile
}

cdh() {
    if [ "$1" == '-?' ]; then 
        cat << USAGE
cdhistory: cdh [n]

Options:
  n         Get the latest number of unique directories [default: 15]

Selections:
  q         Quit
  .         Display the original list
  .<regex>  Filter the current list
  #         Change directory
USAGE
        return 1
    fi
    local IFS=$'\n'
    local directories=()
    #//for line in `tac $cdHistoryFile | head -n ${1:-15}`; do directories+=($line); done
    for line in `tac $cdHistoryFile`; do directories+=($line); done
    cnt=${#directories[@]}
    for ((i = 0; i < cnt - 1; i++)) {
        for ((j = i + 1; j < cnt; j++)) {
            [ "${directories[$i]}" == "${directories[$j]}" ] && unset directories[$j]
        }
    }
    directories=("${directories[@]:0:${1:-15}}")    #// Splice the top results
    local select=0 subset=("${directories[@]}") 
    until [ $select -eq 1 ]; do
        select dir in ${subset[@]}; do 
            case $REPLY in 
                q) select=1; break ;; 
               \.) subset=("${directories[@]}"); break ;;
               .*) subset=($(printf '%s\n' "${subset[@]}" | egrep "${REPLY:1}")); break ;;
                *) cd $dir; select=1; break
            esac
        done
    done
}

#/* vim: set nu cul nows et: */
