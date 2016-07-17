#!/bin/bash

brew install ansible git

ansible-playbook -i "localhost," -c local homebrew.yml $*
