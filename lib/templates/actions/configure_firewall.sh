# install if not already present
if gearship.install "ufw"; then
    apt-get -y install ufw
fi

# configure ufw
if ufw status | grep -q 'Status: active'; then
  echo "ufw already configured, skipping."
else
  
  # make sure ssh connection is not dropped
  ufw allow ssh       
  
  # enable firewall
  ufw --force enable
  ufw allow ssh
  ufw allow http
  ufw allow https
fi
