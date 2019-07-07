# .zprofile
# runs after .zshenv, /etc/zprofile

# prepend paths idempotentally
for addpath in \
  $HOME/bin \
  $HOME/.rbenv/shims \
  $HOME/.mos/bin \
  $GOPATH/bin \
  /usr/local/sbin \
  ; do
  if [[ -z ${path[(r)${addpath}]} ]]; then
    if [[ -d $addpath ]]; then
      # path+=$addpath
      export PATH=$addpath:$PATH
    fi
  fi
done

