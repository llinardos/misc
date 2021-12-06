#!/bin/bash
function usage {
  echo "Switches between ssh identities to simplify managing two githubs account in same computer."
  echo ""
    echo "usage:"
    echo ''
    echo 'ssh-switch-to mine: enables personal key'
    echo 'ssh-switch-to work: enables work key'
    echo ''
    echo 'Options:'
    echo '-h : show this doc'
}

function switch-from-to {
  from=$1
  to=$2
  echo "Switching from ${from} to ${to}"
  # eval `ssh-add -d "~/.ssh/${PERSONAL}"`
  disableFromCmd="ssh-add -d ~/.ssh/${from}"
  output=$(eval ${disableFromCmd})
  # echo $output
  enableToCmd="ssh-add ~/.ssh/${to}"
  output=$(eval ${enableToCmd})
  # echo $output
}

function check-ssh-access {
  echo "Checking ssh access..."
  echo `ssh -T git@github.com`
}

if [ "$#" -lt 1 ]; then
  usage
  exit 1
fi

PERSONAL=llinardos-GitHub
WORK=leandro-linardos-airtime-GitHub

if [ $1 == "mine" ]
then
  switch-from-to ${WORK} ${PERSONAL}
  check-ssh-access
elif [ $1 == "work" ]
then
  switch-from-to ${PERSONAL} ${WORK}
  check-ssh-access
else 
  # check-ssh-access
  usage
fi

exit 1