#!/usr/bin/env bash

# ---------------------------------------------

# Detect os
os::get_name() {
  if [[ "$(uname -s)" == "Linux" ]]; then
    echo "linux"
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    echo 'macos'
  else
    echo 'dafuq'
  fi
}

# Verify the running os
os::verify() {
  local names="$@"
  local current="$(os::get_name)"

  if [[ ! " ${names[*]} " == *" ${current} "* ]]; then
    output::divider
    output::status "Not suitable for $current"
    return 1
  fi
}
