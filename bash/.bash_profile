myPath=/mingw64/bin:/bin:/usr/bin:/usr/bin/vendor_perl:/usr/bin/core_perl

#/* Prevent perpetual appending of $myPath */
export PATH="$(echo $PATH | sed "s#\(.*\)\(:$myPath\)#\1#"):$myPath"

export PS1='[\t \W] $ '

LESS_OPTS='-i -R -X -F'
LESS_PROMPT_E='-P=%f %lt/%L?c,%c. p%dt?D/%D. ?Pt%Pt?PB-%PB\% ..b\:%bt?B/%B .?mf\:%i/%m .?e(END) ?xn\:%x..%t'
export LESS="$LESS_OPTS $LESS_PROMPT_E"

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

alias b=builtin

#/* cd */
alias bcd='b cd'
alias cdb=bcd
alias cd-='cdb -'

alias h=hints
alias hi=history
alias j=jobs
alias l='ls -lAF'
alias ll='ls -al --color | less -R'
alias pd='pushd .'
alias ph='dirs -p'
alias rp=realpath

#/********************************************************************************
# * Git
# ********************************************************************************/

gitCmdLogger() {
    local cmd="command git $*"
    local currentBranch=`command git rev-parse --abbrev-ref @`
    #//local currentBranch=`command git rev-parse --abbrev-ref HEAD`   #// Git 1.8.x
    if echo $cmd | egrep '(fetch)|(merge)|(push)|(pull)' &> /dev/null; then
        if local logDir=`command git rev-parse --git-dir 2> /dev/null`/logs; then
            if [ -w "$logDir" ]; then
                local logfile=$logDir/git.log
                echo "--- `date` - $cmd" >> $logfile
                echo "Branch: $currentBranch" >> $logfile
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
#//alias gb='g rev-parse --abbrev-ref HEAD'    #// Git 1.8.x
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
alias gls='g ls-files'
alias go='g config --get remote.origin.url'
alias gr='g reflog --date=iso'
alias gs='g status -s --untracked-files=no'
alias gsh='g show'
alias gst='g stash list'
alias gsu='g status -s --ignored=no'

gm() {
    g b | grep --color=auto rebasing
    local gitDir=`gdir` && grep -Hn . $gitDir/MERGE* $gitDir/REBASE* 2>/dev/null
}

gbtt() {
    gbt --format="'%(if)%(HEAD)%(then)%(HEAD)}%(color:green)%(else) }%(end)%(refname:short)%(color:magenta)|%(committerdate:iso)|%(color:yellow)%(objectname:short)|%(color:white)%(subject)' $@ --color=always | column -ts'|'"
}

#/********************************************************************************
# * CD
# ********************************************************************************/

cdHistoryDir=~/.cdh
cdHistoryFileDefault=$cdHistoryDir/.bash_cdhistory
mkdir -pv $cdHistoryDir

parseCdCmdline() {
    printCdEnvironment() {
        cat << ENV
  historyFile=$historyFile
  cdHistoryFile=$cdHistoryFile
  cdHHistoryFile=$cdHHistoryFile
  cdHistoryFileDefault=$cdHistoryFileDefault
ENV
    }

    printCdUsage() {
        cat << USAGE
Usage: cd  [-r] [-e] [-n | [{[-l] -{t|s} file} ...]] [-- builtin_opts] dir
       cdh [-r] [-e] [{[-l] -{t|s} file} ...] [size]

Options:
  l             Menu-driven file selection
  t             cd: Save dir to file; cdh: Refer to file
  s             Switch to file for cd and cdh (. = default)
  n             Don't write dir to file
  r             Reset default environment
  e             Print environment
  builtin_opts  Bash builtin options (see \`\`man cd'')

Arguments:
  file          A file name
  dir           A directory name
  size          Number of directories (see \`\`cdh -?'')

Notes:
  cdh references cd's file unless overridden by -s.

  -l must preceed each -t and -s.

  Tip: Replace file with a dummy string for -t and -s when -l is used (eg. ".").

  \$historyFile should always be empty.

Examples:
  cd /tmp
  cd -t file /tmp
  cd -s file /tmp
  cd -s . /tmp
  cd -t file1 -s file2 /tmp
  cd -t file1 -s . /tmp
  cd -r -e -l -t . -l -s . /tmp

  cdh
  cdh 10
  cdh -t file
  cdh -s file 20
  cdh -s .
  cdh -t file1 -s file2 30
  cdh -t file1 -s .
  cdh -r -e -l -t . -l -s . 40

Environment:
`printCdEnvironment`
USAGE
    }

    local OPTIND optArg lOptArg lOptHistoryFile
    while getopts "lt:s:nre?" opt; do
        case $opt in
            l)
                select lOptHistoryFile in `ls -A1 $cdHistoryDir`; do break; done
                lOptHistoryFile=$cdHistoryDir/$lOptHistoryFile
                if [ -f $lOptHistoryFile ]; then
                    lOptArg=$lOptHistoryFile
                else
                    return 1
                fi ;;
            t)
                optArg=${lOptArg:-$OPTARG}
                unset lOptArg
                if [ -w $optArg ]; then
                    historyFile=`realpath -s $optArg`
                else
                    historyFile=$cdHistoryDir/`basename $optArg`
                fi ;;
            s)
                optArg=${lOptArg:-$OPTARG}
                unset lOptArg
                if [ $optArg == . ]; then
                    [ $callingFunction == cd  ] && unset cdHistoryFile
                    [ $callingFunction == cdh ] && unset cdHHistoryFile
                elif [ -w $optArg ]; then
                    [ $callingFunction == cd  ] && cdHistoryFile=`realpath -s $optArg`
                    [ $callingFunction == cdh ] && cdHHistoryFile=`realpath -s $optArg`
                else
                    [ $callingFunction == cd  ] && cdHistoryFile=$cdHistoryDir/`basename $optArg`
                    [ $callingFunction == cdh ] && cdHHistoryFile=$cdHistoryDir/`basename $optArg`
                fi ;;
            n)
                cdNoOp=true ;;
            r)
                unset historyFile cdHistoryFile cdHHistoryFile ;;
            e)
                printCdEnvironment ;;
            ?)
                printCdUsage
                return 1 ;;
        esac
    done
    optInd=$OPTIND
}

cd() {
    callingFunction=$FUNCNAME
    parseCdCmdline $*
    if [[ $? -eq 0 ]]; then
        shift $(($optInd - 1))
        if [ ${#@} -gt 0 ]; then
            if [ $cdNoOp ]; then
                builtin cd "$@"
            else
                builtin cd "$@" && echo $PWD >> ${historyFile:-${cdHistoryFile:-$cdHistoryFileDefault}}
            fi
        fi
    fi
    unset historyFile cdNoOp
}

cdl() {
    cd "$@" && l
}

cdh() {
    if [ "$1" == '-?' ]; then
        cat << USAGE
cdhistory: cdh [n]

Options:
  n             Get the latest number of unique directories [default: 15]

Selections:
  q             Quit
  .             Display the original list
  .<regex>      Filter the current list
  #             Change directory

Also see \`\`cd -?''.
USAGE
        return 1
    fi

    local IFS=$'\n'
    local directories=()

    #/* Parse options */
    callingFunction=$FUNCNAME
    parseCdCmdline $*

    #/* Process directories */
    if [[ $? -eq 0 ]]; then
        shift $(($optInd - 1))
        historyFile=${historyFile:-${cdHHistoryFile:-${cdHistoryFile:-$cdHistoryFileDefault}}}

        if [ -f $historyFile -a -r $historyFile ]; then
            #/* Populate directories */
            for line in `tac $historyFile`; do directories+=($line); done

            #/* Remove duplicates */
            cnt=${#directories[@]}
            for ((i = 0; i < cnt - 1; i++)) {
                for ((j = i + 1; j < cnt; j++)) {
                    [ "${directories[$i]}" == "${directories[$j]}" ] && unset directories[$j]
                }
            }

            #/* Crop results */
            directories=("${directories[@]:0:${1:-15}}")    #// Splice the top results

            #/* Display menu */
            local select=0 subset=("${directories[@]}")
            until [ $select -eq 1 ]; do
                echo source: $historyFile
                select dir in ${subset[@]}; do
                    case $REPLY in
                        q) select=1; break ;;
                       \.) subset=("${directories[@]}"); break ;;
                       .*) subset=($(printf '%s\n' "${subset[@]}" | egrep "${REPLY:1}")); break ;;
                        *) builtin cd $dir; select=1; break
                    esac
                done
            done
        else
            echo $historyFile not regular file or unreadable
        fi
    fi

    unset historyFile cdNoOp
}

#/* vim: set nu cul nows et: */
