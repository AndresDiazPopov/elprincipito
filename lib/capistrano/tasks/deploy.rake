namespace :deploy do

  # after "deploy", "delayed_job:restart"
  # after "deploy", "sitemap:refresh"
  
  desc "Performs the initial setup"
  task :setup do
    on primary fetch(:migration_role) do
      invoke 'deploy:upload_application_yml'
      invoke 'deploy'
    end
  end

  desc "Uploads the application.yml config file"
  task :upload_application_yml do
    on primary fetch(:migration_role) do

      args = {
        :rails_env => "#{fetch(:rails_env)}",
        :secret_key_base => "#{fetch(:secret_key_base)}",
        :secret_token => "#{fetch(:secret_token)}",
        :app_name => "#{fetch(:app_name)}",
        :ga_tracker => "#{fetch(:ga_tracker)}",
        :devise_secret_key => "#{fetch(:devise_secret_key)}",
        :app_domain => "#{fetch(:app_domain)}",
        :protocol => "#{fetch(:protocol)}",
        :mail_from => "#{fetch(:mail_from)}",
        :smtp_address => "#{fetch(:smtp_address)}",
        :smtp_port => "#{fetch(:smtp_port)}",
        :smtp_enable_starttls_auto => "#{fetch(:smtp_enable_starttls_auto)}",
        :smtp_user_name => "#{fetch(:smtp_user_name)}",
        :smtp_password => "#{fetch(:smtp_password)}",
        :smtp_authentication => "#{fetch(:smtp_authentication)}",
        :omniauth_facebook_app_id => "#{fetch(:omniauth_facebook_app_id)}",
        :omniauth_facebook_app_secret => "#{fetch(:omniauth_facebook_app_secret)}",
        :omniauth_twitter_app_id => "#{fetch(:omniauth_twitter_app_id)}",
        :omniauth_twitter_app_secret => "#{fetch(:omniauth_twitter_app_secret)}",
        :omniauth_google_client_id => "#{fetch(:omniauth_google_client_id)}",
        :omniauth_google_client_secret => "#{fetch(:omniauth_google_client_secret)}",
        :db_adapter => "#{fetch(:db_adapter)}",
        :db_encoding => "#{fetch(:db_encoding)}",
        :db_host => "#{fetch(:db_host)}",
        :db_port => "#{fetch(:db_port)}",
        :db_pool => "#{fetch(:db_pool)}",
        :db_name => "#{fetch(:db_name)}",
        :db_user => "#{fetch(:db_user)}",
        :db_password => "#{fetch(:db_password)}",
        :s3_active => "#{fetch(:s3_active)}",
        :s3_region => "#{fetch(:s3_region)}",
        :s3_bucket_name => "#{fetch(:s3_bucket_name)}",
        :s3_access_key => "#{fetch(:s3_access_key)}",
        :s3_access_secret => "#{fetch(:s3_access_secret)}"
      }
      template "application.erb", "/tmp/application.yml", args
      sudo "mv /tmp/application.yml #{shared_path}/config/"
    end
  end

  desc "Seeds the database with seed data"
  task :seed do
    on roles(:db) do
      execute "cd #{current_path} && ( RAILS_ENV=#{fetch(:rails_env)} ~/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do bundle exec rake db:seed )"
    end
  end

  desc "Seeds the database with seed data"
  task :seed_data do
    on roles(:db) do
      execute "cd #{current_path} && ( RAILS_ENV=#{fetch(:rails_env)} ~/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do bundle exec rake db:seed:seed_data )"
    end
  end

  after "deploy", "deploy:seed_data"

  desc "Seeds the database with seed data of the client (WARNING!)"
  task :seed_data_client do
    on roles(:db) do
      execute "cd #{current_path} && ( RAILS_ENV=#{fetch(:rails_env)} ~/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do bundle exec rake db:seed:seed_data_client )"
    end
  end

  desc "Seeds the database with seed data"
  task :seed_data_mock do
    on roles(:db) do
      execute "cd #{current_path} && ( RAILS_ENV=#{fetch(:rails_env)} ~/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do bundle exec rake db:seed:seed_data_mock )"
    end
  end

end