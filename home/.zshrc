# shellcheck source=/dev/null
source $HOME/.zoptions

READNULLCMD=less
REPORTTIME=100
SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zsh_history
unset MANPATH
MANPATH=$(manpath)

HOMEBREW_PREFIX=/usr/local

# bindkey -e

# hub: git wrapper
# This has to go early since everything is terrible
# https://github.com/github/hub/issues/231
if which hub > /dev/null; then
    eval "$(hub alias -s)"
    if [[ -z ${fpath[(r)/usr/local/share/zsh/site-functions]} ]]; then
        fpath+=/usr/local/share/zsh/site-functions
    fi
fi

# get ec2 instance name
if [ -x /usr/bin/ec2metadata ]; then
  export AWS_DEFAULT_REGION
  AWS_DEFAULT_REGION=$(ec2metadata  --availability-zone | sed 's/\([0-9][0-9]*\)[a-z]*$/\1/')
  instance=$(ec2metadata --instance-id)
  HOST=$(aws ec2 describe-tags --filters Name=resource-id,Values="$instance" --query 'Tags[].Value' --output=text)
fi

autoload -U colors && colors

# unalias run-help
# autoload run-help
# HELPDIR=/usr/local/share/zsh/help

# zsh-git-prompt
# https://github.com/olivierverdier/zsh-git-prompt
[ -f "$HOME/dev/zsh-git-prompt/zshrc.sh" ] && source "$HOME/dev/zsh-git-prompt/zshrc.sh"
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CACHE=true
[ -f "$__GIT_PROMPT_DIR/src/.bin/gitstatus" ] && GIT_PROMPT_EXECUTABLE="haskell"

ps_git_super_status() {
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
        echo "git:$(git_super_status) "
    fi
}

ps_aws_default_profile() {
    if [ -n "$AWS_PROFILE" ]; then
        echo "%{$fg[red]%}aws:${AWS_PROFILE}%{$reset_color%} "
    fi
}

ps_cwd() {
    echo "%{$fg[green]%}%20<...<%~%{$reset_color%}"
}

ps_hostname() {
    echo "%{$fg[cyan]%}%m%{$reset_color%}"
}

ps_retcode() {
    echo "%(?..!%?! )"
}

ps_roothash() {
    # echo "%{$fg[magenta]%}%#%{$reset_color%}"
    if [[ "$(whoami)" == "root" ]]; then
        hashmark='🚀"'
    else
        hashmark='%%'
    fi
    echo "%{$fg[magenta]%}$hashmark%{$reset_color%}"
}

ps_virtual_env() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "%{$fg[yellow]%}env:$(basename "$VIRTUAL_ENV")%{$reset_color%} "
    else
        PYENV_LOCAL=$(pyenv local 2> /dev/null | head -1)
        if [ -n "$PYENV_LOCAL" ]; then
            echo "%{$fg[yellow]%}pyenv:$PYENV_LOCAL%{$reset_color%} "
        fi
    fi
}

PS1='$(ps_hostname) $(ps_retcode)$(ps_roothash) '
RPROMPT='$(ps_virtual_env)$(ps_git_super_status)$(ps_aws_default_profile)$(ps_cwd)'

source "$HOME/.zaliases"
if [ -f "$HOME/.ssh_agent" ]; then
    source "$HOME/.ssh_agent"
fi

# history substring search
# bind P and N for EMACS mode
if [ -f /usr/local/opt/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
   source /usr/local/opt/zsh-history-substring-search/zsh-history-substring-search.zsh
   bindkey -M emacs '^P' history-substring-search-up
   bindkey -M emacs '^N' history-substring-search-down
fi

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

if ( which direnv > /dev/null ); then
    eval "$(direnv hook zsh)"
fi

zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit && compinit -i


if [ "$USER" != "root" ]; then
  compinit
  test -f /usr/local/share/zsh/site-functions/_aws && source /usr/local/share/zsh/site-functions/_aws
  test -f /usr/share/zsh/vendor-completions/_awscli && source /usr/share/zsh/vendor-completions/_awscli
  #test -f /usr/local/bin/aws_zsh_completer.sh && source /usr/local/bin/aws_zsh_completer.sh
fi

# add zsh completions idempotentally
for compl in \
        /usr/local/share/zsh-completions \
        /usr/local/share/zsh/site-functions \
    ; do
    # Return the index of the searched-for element
    # It will return one greater than the number of elements if not found
    if [[ -z ${fpath[(r)${compl}]} ]]; then
        if [[ -d $compl ]]; then
            fpath+=$compl
        fi
    fi
done

autoload -Uz compinit && compinit -i

for source in \
    /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh \
    /usr/local/share/zsh/site-functions/git-flow-completion.zsh \
    ; do
    if [ -f "$source" ]; then
        source "$source"
    fi
done


# if ( which direnv > /dev/null ); then
#   _gh_completion() {
#     COMPREPLY=( $( env COMP_WORDS="${COMP_WORDS[*]}" \
#                    COMP_CWORD="$COMP_CWORD" \
#                    _GH_COMPLETE=complete "$1" ) )
#     return 0
#   }
#   complete -F _gh_completion -o default gh;
# fi

#if [ "$USER" != "root" ] && (which docker-machine > /dev/null); then
#    eval "$(docker-machine env dev 2> /dev/null)"
#fi

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# disable virtualenv prompt prepending since it's done in RPROMPT
VIRTUAL_ENV_DISABLE_PROMPT=1

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# ruby
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# added by travis gem
[ -f /Users/jgross/.travis/travis.sh ] && source /Users/jgross/.travis/travis.sh

# GPG agent
GPG_AGENT_FILE="${HOME}/.gnupg/S.gpg-agent"
if [[ $(uname -s) == "Darwin" ]]; then
  PINENTRY="--pinentry-program /usr/local/bin/pinentry-mac"
fi
function start_gpg_agent {
  # gpg-agent --daemon --write-env-file $GPG_AGENT_FILE --pinentry-program $PINENTRY
  gpg-agent --daemon "${PINENTRY}"
}
if which gpg-agent > /dev/null; then
  # start agent if there's no agent file
  if [ ! -S "${GPG_AGENT_FILE}" ]; then
    eval "$( start_gpg_agent )"
  else
    # check agent connection
    if ( ! nc -U "${GPG_AGENT_FILE}" < /dev/null | grep -q "OK Pleased to meet you" ); then
      eval "$( start_gpg_agent )"
    fi
  fi
  GPG_TTY=$(tty)
  export GPG_TTY
fi
# zpretzo
# [ -f $HOME/.zprezto/init.zsh ] && source $HOME/.zprezto/init.zsh

# iterm3 shell integration
#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
