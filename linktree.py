#!/usr/bin/env python

import argparse
import errno
import logging
import os
import os.path

logger = logging.getLogger(__name__)


# Create symlink tree of dotfiles
# Handles subdirectories
def linktree():
    homedir = os.getenv('HOME')
    os.chdir('home')
    cwd = os.getcwd()

    for root, _, files in os.walk('.'):
        sourcedir = os.path.join(homedir, root)
        logger.debug(sourcedir)
        if not os.path.isdir(sourcedir):
            try:
                os.remove(sourcedir)
            except OSError as e:
                if not e.errno == errno.ENOENT:
                    raise e
            logger.info("mkdir: %s" % sourcedir)
            os.mkdir(sourcedir)
        for f in files:
            source = os.path.normpath(os.path.join(cwd, root, f))
            target = os.path.normpath(os.path.join(homedir, root, f))
            if not os.path.islink(target):
                if os.path.isfile(target):
                    os.remove(target)
                logger.info("linking: %s", target + " -> " + source)
                os.symlink(source, target)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', dest='loglevel', action='store_const',
                        const=logging.DEBUG, default=logging.INFO)
    args = parser.parse_args()
    logging.basicConfig()
    logger.setLevel(args.loglevel)
    linktree()
