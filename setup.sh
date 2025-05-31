#! /bin/bash

set -euo pipefail

# Check OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Setting up linux machine"
else
  echo "Did not setup that OS yet"
  exit 1
fi

if ! hash ansible >/dev/null 2>&1; then
    echo "You must install ansible before running this"
    exit 1
fi

ansible-galaxy collection install community.general

ansible-playbook main.yml -K -i hosts
