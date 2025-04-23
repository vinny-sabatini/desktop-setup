#! /bin/bash

set -euo pipefail

# Setup directories
TECH_DIR=$HOME/tech
PROJ_DIR=$HOME/projects
mkdir -p $TECH_DIR/bin
mkdir -p $PROJ_DIR

PATH=$PATH:$TECH_DIR/bin:$HOME/.krew/bin

# Check OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Setting up linux machine"
else
  echo "Did not setup that OS yet"
  exit 1
fi

# Install CRC
wget https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/crc/2.31.0/crc-linux-amd64.tar.xz
tar -xf crc-linux-amd64.tar.xz
chmod +x $(find -name "crc")
mv $(find -name "crc") $TECH_DIR/bin
rm -rf crc*

# Install krew
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
  kubectl krew upgrade
)

# Install krew kubectl plugins
kubectl krew install ctx ns access-matrix foreach gke-policy konfig neat oidc-login sick-pods sniff view-secret whoami

# Setup oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Add dotfiles
cp -r ./dotfiles/. $HOME

# Fix kind "too many open files" issue
# https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files
# sudo cat << EOF >> /etc/sysctl.conf
# fs.inotify.max_user_watches = 524288
# fs.inotify.max_user_instances = 512
# EOF


if ! hash ansible >/dev/null 2>&1; then
    echo "You must install ansible before running this"
    exit 1
fi

ansible-galaxy collection install community.general

ansible-playbook main.yml -K -i hosts
