#!/bin/sh

HOST=$1
shift


ansible-playbook -i $HOST, -kK main.yml $@
