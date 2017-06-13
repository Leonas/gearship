docker login -u="<%= @attributes.docker_username %>" -p="<%= @attributes.docker_password %>"
docker pull <%= @attributes.app_repo %>
