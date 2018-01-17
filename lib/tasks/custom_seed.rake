namespace :db do
  namespace :seed do
    Dir[Rails.root.join('db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb').intern    
      task task_name => :environment do
        load(filename) if File.exist?(filename)
      end
    end

    seed_data_files = %w[admin_user]

    task :seed_data => :environment do
      seed_data_files.each do |filename|
        file = Rails.root.join('db', 'seeds', filename + '.rb')
        load(file) if File.exist?(file)
      end
    end

    seed_data_mock_files = %w[mock_users mock_mobile_operating_systems
        mock_mobile_operating_system_versions mock_device_manufacturers mock_device_models 
        mock_devices mock_logins]

    task :seed_data_mock => :environment do
      seed_data_mock_files.each do |filename|
        file = Rails.root.join('db', 'seeds', filename + '.rb')
        load(file) if File.exist?(file)
      end
    end

  end
end