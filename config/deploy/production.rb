# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:
server "52.27.248.151", user: "deploy", roles: %w{web app db}
