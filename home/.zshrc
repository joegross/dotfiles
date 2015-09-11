source $HOME/.zoptions

READNULLCMD=less
REPORTTIME=100
SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zsh_history
unset MANPATH
MANPATH=$(manpath)

HOMEBREW_PREFIX=/usr/local

bindkey -e

# get ec2 instance name
if [ -x /usr/bin/ec2metadata ]; then
    export AWS_DEFAULT_REGION=$(ec2metadata  --availability-zone | sed 's/\([0-9][0-9]*\)[a-z]*$/\1/')
    instance=$(ec2metadata --instance-id)
    HOST=$(aws ec2 describe-tags --filters Name=resource-id,Values=$instance --query 'Tags[].Value' --output=text)
fi

autoload -U colors && colors

# zsh-git-prompt
# https://github.com/olivierverdier/zsh-git-prompt
[ -f $HOME/dev/zsh-git-prompt/zshrc.sh ] && source $HOME/dev/zsh-git-prompt/zshrc.sh
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

ps_git_super_status() {
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
        echo "git:$(git_super_status) "
    fi
}

ps_aws_default_profile() {
    if [ -n "$AWS_DEFAULT_PROFILE" ]; then
        echo "%{$fg[red]%}aws:${AWS_DEFAULT_PROFILE}%{$reset_color%} "
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
        echo "%{$fg[yellow]%}env:$(basename $(dirname $(dirname $VIRTUAL_ENV)))%{$reset_color%} "
    fi
}

PS1='$(ps_hostname) $(ps_retcode)$(ps_roothash) '
RPROMPT='$(ps_virtual_env)$(ps_git_super_status)$(ps_aws_default_profile)$(ps_cwd)'

source $HOME/.zaliases
if [ -f $HOME/.ssh_agent ]; then
    source $HOME/.ssh_agent
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

autoload -Uz compinit
compinit -u

test -f /usr/local/share/zsh/site-functions/_aws && source /usr/local/share/zsh/site-functions/_aws
#test -f /usr/local/bin/aws_zsh_completer.sh && source /usr/local/bin/aws_zsh_completer.sh

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

for source in \
    /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh \
    ; do
    if [ -f "$source" ]; then
        source $source
    fi
done

#if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
#fi

# docker
#if [ -n "$(which boot2docker)" ]; then
#    eval $(boot2docker shellinit)
#fi

if [ -n "$(which docker-machine) )" ]; then
    eval "$(docker-machine env docker-vm)"
fi

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
# export PYENV_ROOT=/usr/local/var/pyenv
