# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:
AWS.config(access_key_id: ENV["AWS_ACCESS_KEY_ID"],
           secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
           region: "us-west-2")
ec2_instance = AWS.ec2.instances.with_tag("Name", "cards-app").first
server ec2_instance.ip_address, user: "deploy", roles: %w{web app db}
