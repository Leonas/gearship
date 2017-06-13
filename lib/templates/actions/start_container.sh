docker run --name <%= @attributes.container_name %> \
           --publish <%= @attributes.container_port_map %> \
           --restart always \
           --detach \
           <%= @attributes.container_repo %>
