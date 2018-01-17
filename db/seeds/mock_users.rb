require 'factory_girl_rails'

FactoryGirl.create_list(:identity, 30, :google_oauth2)
FactoryGirl.create_list(:identity, 30, :facebook)
FactoryGirl.create_list(:identity, 30, :twitter)