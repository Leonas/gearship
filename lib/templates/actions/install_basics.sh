# Update apt catalog and upgrade installed packages
gearship.mute "apt-get update"
gearship.mute "apt-get -y upgrade"

# install most important packages
apt-get -y install git ntp curl
