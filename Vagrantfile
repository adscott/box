# -*- mode: ruby -*-
# vi: set ft=ruby :


def install_tmux(version)
<<-SCRIPT
set -e
rm -rf /tmp/tmux
mkdir /tmp/tmux
cd /tmp/tmux
curl -LOk https://github.com/tmux/tmux/releases/download/#{version}/tmux-#{version}.tar.gz
tar -xf tmux-#{version}.tar.gz
cd tmux-#{version}
./configure
make
make install
SCRIPT
end

def install_vim()
<<-SCRIPT
set -e
rm -rf /tmp/vim
git clone https://github.com/vim/vim.git /tmp/vim
cd /tmp/vim
./configure
make
make install
SCRIPT
end

def install_dotfiles()
<<-SCRIPT
set -e
git clone https://github.com/adscott/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
SCRIPT
end

Vagrant.configure("2") do |config|
    config.vm.box = "centos/7"
    config.vm.hostname = "sandbox"
    config.vm.network "public_network", bridge: "public_network"

    config.ssh.forward_agent = true

    config.vm.provider "hyperv" do |h|
        h.cpus = 12
        h.memory = 8192
        h.linked_clone = true
    end

    config.vm.provision "shell", inline: "yum install -y epel-release"
    config.vm.provision "shell", inline: "yum update -y"
    config.vm.provision "shell", inline: "yum install -y libevent ncurses libevent-devel ncurses-devel gcc make bison pkg-config git python3 python3-devel htop"
    config.vm.provision "shell", inline: install_tmux("2.8")
    config.vm.provision "shell", inline: install_vim()
    config.vm.provision "shell", inline: install_dotfiles(), privileged: false
    config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
    config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
    config.vm.provision "shell", inline: "chmod 600 /home/vagrant/.ssh/id_rsa", privileged: false

    config.vm.provision "shell", path: "./scripts/install-docker.sh"

    config.vm.provision "shell", path: "./scripts/configure-static-ip.sh"
    config.vm.provision :reload
end
