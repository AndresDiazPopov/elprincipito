# config valid only for Capistrano 3.1
lock '3.8.2'

set :repo_url, 'git@bitbucket.org:softwhisper/backend-template.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :branch, ENV['branch'] || 'master'

set :user, "deployer"

set :use_sudo, false

set :rails_env, "production"

set :ssh_options, { :forward_agent => true }

set :rvm_type, :user

set :rvm_ruby_version, '2.3.0@BackendTemplate'

set :slackistrano, {
  channel: '#APP-ci',
  webhook: 'https://hooks.slack.com/............',
  klass: Slackistrano::CustomMessaging
}

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, false

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}
set :linked_files, %w{config/application.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{ log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
# set :linked_dirs, %w{ log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute "mkdir -p #{release_path}/tmp"
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

end
