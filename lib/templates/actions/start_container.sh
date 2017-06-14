docker run --name <%= @attributes.container_name %> \
           --publish <%= @attributes.container_port_map %> \
           --restart always \
           <%= @attributes.container_repo %>
