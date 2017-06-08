if gearship.install "docker-ce"; then
    sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
    
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
   
    sudo apt-get update
    sudo apt-get install -y docker-ce
fi
