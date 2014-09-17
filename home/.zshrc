source $HOME/.zoptions

READNULLCMD=less
REPORTTIME=100
SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zsh_history
unset MANPATH
MANPATH=$(manpath)

bindkey -e

autoload -U colors && colors
PS1='%{$fg[cyan]%}%m %{$fg[green]%}(%35<...<%~)%{$reset_color%} %(?..!%?! )%{$fg[magenta]%}%#%{$reset_color%} '
#PROMPT2="more> "
#PROMPT3="Choice? "
#PROMPT4="+ "
RPROMPT=%~


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
function precmd() {
    title "zsh" "%m:%55<...<%~"
}

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

#    install_powerline_precmd
