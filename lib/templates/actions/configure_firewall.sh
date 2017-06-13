# install if not already present
if gearship.install "ufw"; then
    apt-get -y install ufw
fi

ufw --force enable
ufw allow ssh       
ufw allow http
ufw allow https
