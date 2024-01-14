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

# Install
# powerline-go?
# venv

# Install Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
mv ./kind $TECH_DIR/bin/kind

# Install Insomnia
sudo dnf install -y https://github.com/Kong/insomnia/releases/download/core%408.5.1/Insomnia.Core-8.5.1.rpm

# Install CRC
wget https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/crc/2.31.0/crc-linux-amd64.tar.xz
tar -xf crc-linux-amd64.tar.xz
chmod +x $(find -name "crc")
mv $(find -name "crc") $TECH_DIR/bin
rm -rf crc*

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl $TECH_DIR/bin

# Install krew
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

# Install kubectx/ns
kubectl krew install ctx
kubectl krew install ns

# Setup yum repos
sudo cp ./yum-repos/* /etc/yum.repos.d/
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y update
sudo dnf -y install $(cat rpms.txt)

# virtualenv install
pip install virtualenv

# Setup oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Add dotfiles
cp -r ./dotfiles/. $HOME
