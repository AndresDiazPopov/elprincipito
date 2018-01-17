Rails.application.configure do
  GA.tracker = ENV["ga_tracker"]
end