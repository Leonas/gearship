docker login -u="<%= @attributes.docker_username %>" -p="<%= @attributes.docker_password %>"
docker pull <%= @attributes.app_repo %>
docker run --name=<%= @attributes.app_name %> \
           --publish=<%= @attributes.app_port_map %> \
           --restart=always \
           --detach \
           <%= @attributes.app_repo %>
