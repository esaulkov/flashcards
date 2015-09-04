# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:
require "aws-sdk"
credentials = YAML.load_file("config/aws.yml")
puts credentials
AWS.config(credentials)

ec2_instance = AWS.ec2.instances.with_tag("Name", "cards-app").first
server ec2_instance.ip_address, user: "deploy", roles: %w{web app db}
