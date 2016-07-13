#!/bin/bash

ansible-playbook -i "localhost," -c local site.yml $*
