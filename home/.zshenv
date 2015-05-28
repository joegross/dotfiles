# .zshenv

OSTYPE=$(uname -s |sed -e 's/GNU\///')
export EDITOR=emacs
export LESS=iMFXR
# add extra paths completions idempotentally
for addpath in \
    $HOME/bin \
    /srv/genops/tools \
    ; do
    # Return the index of the searched-for element
    # It will return one greater than the number of elements if not found
    if [[ ${fpath[(i)${addpath}]} -gt ${#fpath} ]]; then
        if [[ -d $addpath ]]; then
            path+=$addpath
        fi
    fi
done
if [[ -f ~/.github_token ]]; then
    export HOMEBREW_GITHUB_API_TOKEN=$(cat $HOME/.github_token)
fi
export LESSCHARSET='UTF-8'
export LESS_TERMCAP_mb=$'\e[01;32m'
export LESS_TERMCAP_md=$'\e[0;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[0;30;43m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[0;31m'
#export LESS_TERMCAP_us=$'\E[01;32m'
export GREP_OPTIONS='--color=auto'
export CLICOLOR=yes
export CLICOLOR_FORCE=yes

if [[ -d /usr/local/opt/android-sdk ]]; then
  export ANDROID_HOME=/usr/local/opt/android-sdk
fi

# docker
if [[ -x /usr/local/bin/boot2docker ]]; then
    $(/usr/local/bin/boot2docker shellinit 2> /dev/null)
fi

# nextopio
export ANDROID_HOME="/usr/local/opt/android-sdk"
