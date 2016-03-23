#!/usr/bin/env python

import os
import os.path

homedir = os.getenv('HOME')
os.chdir('home')
cwd = os.getcwd()

for root, _, files in os.walk('.'):
    print root
    sourcedir = os.path.join(homedir, root)
    if not os.path.isdir(sourcedir):
        if os.path.islink(sourcedir):
            os.remove(sourcedir)
        if os.path.isdir(sourcedir):
            os.rmdir(sourcedir)
        os.mkdir(sourcedir)
    for f in files:
        source = os.path.normpath(os.path.join(cwd, root, f))
        target = os.path.normpath(os.path.join(homedir, root, f))
        if not os.path.islink(target):
            os.symlink(source, target)
