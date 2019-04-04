# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role

set :application,                       ENV['elprincipito'] || 'elprincipito'
set :app_name,                          "#{fetch(:application)}".downcase.strip

set :sidekiq_env,                       "#{fetch(:rails_env)}"

set :branch,                            ENV['branch'] || 'master'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/srv/rails/#{fetch(:app_name)}"


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
server 'ec2-18-184-154-208.eu-central-1.compute.amazonaws.com',
  user: 'deployer',
  roles: %w{web app db},
  ssh_options: {
    user: 'deployer', # overrides user setting above
    forward_agent: true,
    auth_methods: %w(publickey password)
    # password: 'please use keys'
  }
# setting per server overrides global ssh_options
