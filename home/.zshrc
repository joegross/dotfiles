source $HOME/.zoptions

READNULLCMD=less
REPORTTIME=100
SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zsh_history
unset MANPATH
MANPATH=$(manpath)

bindkey -e

# get ec2 instance name
if [ -x /usr/bin/ec2metadata ]; then
    export AWS_DEFAULT_REGION=$(ec2metadata  --availability-zone | sed 's/\([0-9][0-9]*\)[a-z]*$/\1/')
    instance=$(ec2metadata --instance-id)
    HOST=$(aws ec2 describe-tags --filters Name=resource-id,Values=$instance --query 'Tags[].Value' --output=text)
fi

autoload -U colors && colors
PS1='%{$fg[cyan]%}%m %{$fg[green]%}(%15<...<%~)%{$reset_color%} %(?..!%?! )%{$fg[magenta]%}%#%{$reset_color%} '
#PROMPT2="more> "
#PROMPT3="Choice? "
#PROMPT4="+ "
RPROMPT='%{$fg[green]%}%~%{$reset_color%}'


function title() {
    # escape '%' chars in $1, make nonprintables visible
    local a=${(V)1//\%/\%\%}

    # Truncate command, and join lines.
    a=$(print -Pn "%40>...>$a" | tr -d "\n")

    case $TERM in
        screen)
            TERM=screen-256color
            ;;
        screen*)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            print -Pn "\ek$a\e\\"      # screen title (in ^A")
            print -Pn "\e_$2   \e\\"   # screen location
            ;;
        xterm*)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            ;;
    esac
}

# precmd is called just before the prompt is printed
#function precmd() {
#    title "zsh" "%m:%55<...<%~"
#}

# preexec is called just before any command line is executed
#function preexec() {
#    title "$1" "%m:%35<...<%~"
#}

source $HOME/.zaliases
if [ -f $HOME/.ssh_agent ]; then
    source $HOME/.ssh_agent
fi

function powerline_precmd() {
    export PS1="$(~/powerline-shell.py $? --shell zsh 2> /dev/null)"
}

function install_powerline_precmd() {
    for s in "${precmd_functions[@]}"; do
        if [ "$s" = "powerline_precmd" ]; then
            return
        fi
    done
    precmd_functions+=(powerline_precmd)
}

for source in \
        /usr/local/bin/aws_zsh_completer.sh \
        /usr/share/zsh/vendor-completions/_awscli \
        /usr/local/share/zsh/site-functions/_aws \
        /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh \
    ; do
    if [ -f "$source" ]; then
        source $source
    fi
done

# history substring search
# bind P and N for EMACS mode
if [ -f /usr/local/opt/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
   source /usr/local/opt/zsh-history-substring-search/zsh-history-substring-search.zsh
   bindkey -M emacs '^P' history-substring-search-up
   bindkey -M emacs '^N' history-substring-search-down
fi

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# add zsh completions idempotentally
for compl in \
        /usr/local/share/zsh-completions \
    ; do
    # Return the index of the searched-for element
    # It will return one greater than the number of elements if not found
    if [[ ${fpath[(i)${compl}]} -gt ${#fpath} ]]; then
        if [[ -d $compl ]]; then
            tmppath+=$p
            fpath+=$comp
        fi
    fi
done


ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
