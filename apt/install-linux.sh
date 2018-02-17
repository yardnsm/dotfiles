#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../_setup/initializer.sh"

# ---------------------------------------------

print_info "Updating apt"

execute "sudo apt-get update -qqy" "apt-get (update)"

# ---------------------------------------------

print_info "Install APT packages"

apt_install 'sudo'
apt_install 'git'
apt_install 'make'
apt_install 'curl'
apt_install 'tmux'
apt_install 'zsh'
apt_install 'ruby-full'
apt_install 'rbenv'

# ---------------------------------------------

print_info "Cleanup"

execute "sudo apt-get autoremove -qqy" "apt-get (autoremove)"
