#!/bin/bash

set -e

base=$(dirname ${BASH_SOURCE})
cd $base
git pull origin master

find home -type f -execdir ln -sf $(pwd)/home/{} ~/{} \;

OSTYPE=$(uname -s |sed -e 's/GNU\///')
exec ./bootstrap-$OSTYPE.sh
