Rails.application.configure do
  # General Settings
  config.app_domain = ENV["app_domain"]

  # Email
  if ENV['delivery_method'] && ENV['delivery_method'] != 'letter_opener'
    config.action_mailer.delivery_method = :smtp
  end

  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: config.app_domain, protocol: ENV["protocol"] }
  config.action_mailer.default_options = {
    :from => ENV["mail_from"]
  }
  config.action_mailer.smtp_settings = {
    address: ENV["smtp_address"],
    port: ENV["smtp_port"].to_i,
    enable_starttls_auto: ENV["smtp_enable_starttls_auto"] == "true",
    user_name: ENV["smtp_user_name"],
    password: ENV["smtp_password"],
    authentication: ENV["smtp_authentication"],
    domain: config.app_domain
  }
end