docker run --name=<%= @attributes.app_name %> \
           --publish=<%= @attributes.app_port_map %> \
           --restart=always \
           --detach \
           <%= @attributes.app_repo %>
