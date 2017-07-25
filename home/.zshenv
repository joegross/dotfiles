# .zshenv

export FCEDIT=emacs
export LESS=iMFXR

if [[ -x /usr/libexec/java_home ]]; then
  JAVA_HOME="$(/usr/libexec/java_home)" && export JAVA_HOME
fi

# prepend paths because homebrew java must come first
# for addpath in \
#     $JAVA_HOME/bin \
#     ; do
#     if [[ -z ${path[(r)${addpath}]} ]]; then
#         if [[ -d $addpath ]]; then
#             path+=$addpath
#         fi
#     fi
# done

export GOPATH=$HOME/gocode

# add extra path completions idempotentally
for addpath in \
  $HOME/bin \
  $GOPATH/bin \
  /usr/local/sbin \
  /usr/local/anaconda3/bin \
  ; do
  if [[ -z ${path[(r)${addpath}]} ]]; then
    if [[ -d $addpath ]]; then
      path+=$addpath
    fi
  fi
done

if [[ -f ~/.github_token ]]; then
  HOMEBREW_GITHUB_API_TOKEN=$(cat "$HOME"/.github_token)
  export HOMEBREW_GITHUB_API_TOKEN
fi
export HOMEBREW_NO_ANALYTICS=1

if [[ -f ~/.atlas_token ]]; then
  ATLAS_TOKEN="$(cat "$HOME"/.atlas_token)"
  export ATLAS_TOKEN
fi

# less colors
export LESSCHARSET='UTF-8'
export LESS_TERMCAP_mb=$'\e[01;32m'
export LESS_TERMCAP_md=$'\e[0;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[0;30;43m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[0;31m'
#export LESS_TERMCAP_us=$'\E[01;32m'
# grep colors
export GREP_COLOR=auto
# ls colors
export CLICOLOR=yes
export CLICOLOR_FORCE=yes

if [[ -d /usr/local/opt/android-sdk ]]; then
  export ANDROID_HOME=/usr/local/opt/android-sdk
fi


export SHELLCHECK_OPTS="-e SC2148 -e SC2034"


if [[ -d /usr/local/opt/groovy/libexec ]]; then
  GROOVY_HOME="/usr/local/opt/groovy/libexec" && export GROOVY_HOME
fi
