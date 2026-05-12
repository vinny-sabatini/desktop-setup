#! /bin/bash

set -euo pipefail

# Check OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Setting up linux machine"
  ANSIBLE_EXTRA_ARGS="--ask-become-pass"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Setting up mac machine"
  ANSIBLE_EXTRA_ARGS=""
else
  echo "Did not setup that OS yet"
  exit 1
fi

if ! hash ansible >/dev/null 2>&1; then
    echo "You must install ansible before running this"
    exit 1
fi

if ! hash git >/dev/null 2>&1; then
    echo "You must install git before running this"
    exit 1
fi

if ! hash pip >/dev/null 2>&1; then
    echo "You must install pip before running this"
    exit 1
fi

# Ansible does not handle
# https://github.com/ansible/ansible/issues/80883
echo "=== WARNING ==="
echo "Ansible does not handle fingerprint sudo well."
echo "Consider disabling with 'authselect disable-feature with-fingerprint'"
echo "And then enabling with 'authselect enable-feature with-fingerprint'"
echo "Or spam your fingerprint during become tasks"

ansible-galaxy collection install community.general

ansible-playbook main.yml -i hosts $ANSIBLE_EXTRA_ARGS
