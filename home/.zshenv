# .zshenv

OSTYPE=$(uname -s |sed -e 's/GNU\///')
export EDITOR=emacs
export LESS=iMFXR
tmppath=()
for p in \
    $HOME/bin \
    /usr/local/sbin \
    /usr/local/bin \
    /opt/local/bin \
    /opt/local/sbin \
    /usr/bin \
    /bin \
    /usr/sbin \
    /sbin \
    /srv/genops/tools \
    ; do
    if [[ -d $p ]]; then
        tmppath+=$p
    fi
done
PATH=$(IFS=:; echo "${tmppath[*]}")
export MANPATH=/usr/local/share/man:/usr/share/man
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
#if [[ -f ~/.dir_colors ]]; then
#	eval $(dircolors -b ~/.dir_colors)
#else
    export LS_COLORS='di=00;34:fi=00:ln=36:pi=31:so=33:bd=44;37:cd=44;37:or=01;41;37:mi=00;31:ex=32:do=00;37:*.tar=00;31:*.tgz=00;31:*.zip=00;31:*.gz=00;31:*.bz2=00;31:*.tbz2=00;31:*.rar=00;31:*.ace=00;31:*.jpg=00;33:*.jpeg=00;33:*.gif=00;33:*.bmp=00;33:*.tga=00;33:*.xpm=00;33:*.tiff=00;33:*.png=00;33:*.mpg=01;33:*.mpeg=01;33:*.avi=01;33:*.mov=01;33:*.wmv=01;33:*.ogm=01;33:*.pdf=01;37:*.ps=01;37:*.txt=01;37:*.log=01;37:*.tex=01;37:*.doc=01;37:*.mp3=00;91:*.c=00;33:*.cc=00;33:*.cpp=00;33:*.h=01;31:*.hpp=01;31'
#fi

if [[ -d /usr/local/opt/android-sdk ]]; then
  export ANDROID_HOME=/usr/local/opt/android-sdk
fi

# docker
if [[ -x /usr/local/bin/boot2docker ]]; then
    $(/usr/local/bin/boot2docker shellinit 2> /dev/null)
fi

