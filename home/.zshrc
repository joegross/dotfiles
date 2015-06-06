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

# prompt
autoload -U colors && colors
function _aws_default_profile {
    if [ -n "$AWS_DEFAULT_PROFILE" ]; then
        echo "%{$fg[red]%}${AWS_DEFAULT_PROFILE}%{$reset_color%} "
    fi
}

PS1='%{$fg[cyan]%}%m %{$fg[green]%}(%20<...<%~)%{$reset_color%} $(_aws_default_profile)%(?..!%?! )%{$fg[magenta]%}%#%{$reset_color%} '
RPROMPT='%{$fg[green]%}%~%{$reset_color%}'

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

# virutalenv
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
 #if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
# export PYENV_ROOT=/usr/local/var/pyenv

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

if ( which direnv > /dev/null ); then
    eval "$(direnv hook zsh)"
fi

autoload -Uz compinit
compinit -u

test -f /usr/local/share/zsh/site-functions/_aws && source /usr/local/share/zsh/site-functions/_aws

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
