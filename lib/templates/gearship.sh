#!/bin/bash

# Main install script. mission scripts get appended to this when executing
# bundle exec gearship setup_host

# Exit immediately if a pipeline returns a non-zero status.
# (unless part of the test in an if statement)
set -e

export DEBIAN_FRONTEND=noninteractive
 
# Mute STDOUT and STDERR
function gearship.mute() {
  echo "Running \"$@\""
  `$@ >/dev/null 2>&1`
  return $?
}

function gearship.installed() {
  dpkg -s $@ >/dev/null 2>&1
  return $?
}

function gearship.install() {
  if gearship.installed "$@"; then
    echo "$@ already installed"
    return 1
  else
    echo "No packages found matching $@. Installing..."
    gearship.mute "apt-get -y install $@"
    return 0
  fi
}

echo "
       ___                      _     _       
      / __| ___  __ _  _ _  ___| |_  (_) _ __ 
     | (_ |/ -_)/ _\` || '_|(_-<| ' \ | || '_ \\
      \___|\___|\__,_||_|  /__/|_||_||_|| .__/
                                        |_|   
                                              
                ___  _ _    __ _              
               / _ \| ' \  / _\` |             
               \___/|_||_| \__,_|             
                                              
                _          _             _    
         _ __  (_) ___ ___(_) ___  _ _  | |   
        | '  \ | |(_-<(_-<| |/ _ \| ' \ |_|   
        |_|_|_||_|/__//__/|_|\___/|_||_|(_)   
                                              

"
