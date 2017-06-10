docker stop <%= @attributes.app_name %>
docker rm <%= @attributes.app_name %>
source actions/start_app.sh
