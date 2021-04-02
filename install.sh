#!/bin/sh


DIR="$(dirname $0)"

HOST=$1
shift

export ANSIBLE_HOST_KEY_CHECKING=False

case "$HOST" in
    "local")
        ansible-playbook -i localhost, -c local -K "$DIR"/main.yml --diff --skip-tags reboot $@
         ;;
    *)
        ansible-playbook -i $HOST, -kK "$DIR"/main.yml --diff $@
        ;;
esac
