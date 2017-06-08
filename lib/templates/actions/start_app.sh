docker login -u="<%= @attributes.docker_username %>" -p="<%= @attributes.docker_password %>"
docker pull <%= @attributes.docker_repo %>
docker run -d -p <%= @attributes.app_port_map %> --name=<%= @attributes.app_name %> --restart=always -d <%= @attributes.app_repo %>
