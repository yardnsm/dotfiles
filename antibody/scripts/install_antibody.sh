#!/usr/bin/env bash

# --------------------------------------------- #
# | Install antibody
# --------------------------------------------- #
if ! cmd_exists 'antibody'; then
  execute "curl -s https://raw.githubusercontent.com/getantibody/installer/master/install | bash -s" \
    "Installing antibody"
else
  print_success 'antibody'
fi
