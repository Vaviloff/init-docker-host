#!/bin/bash
apt update

# zsh
apt install -yq zsh build-essential curl git wget htop tmux mc
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# nvm and node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | zsh

zsh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# node
nvm install 14
npm i -g yarn

# docker
apt install -yq apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt-cache policy docker-ce
apt install -yq docker-ce
# loki logging driver
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions

# docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Non-standard ssh port
if [ "$SSH_PORT" != "" ]; then
  echo "Changing port to $SSH_PORT"
  echo "Port $SSH_PORT" >> /etc/ssh/sshd_config
  service ssh restart
fi

# check
node --version
npm --version
yarn --version
docker --version
docker-compose --version
docker plugin ls
