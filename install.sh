#!/bin/sh

HOST=$1
shift

case "$HOST" in
    "local")
        ansible-playbook -i localhost, -c local -K main.yml --skip-tags reboot $@
         ;;
    "*")
        ansible-playbook -i $HOST, -kK main.yml $@
        ;;
esac
