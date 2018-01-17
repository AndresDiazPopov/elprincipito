require 'rails_helper'

RSpec.describe "Requests", type: :request do
  
  describe "GET /unexistent_url" do
    
    context 'when not logged in as admin' do

      it "redirects to root_url" do
        get '/' + Faker::Lorem.word
        expect(response.status).to eq(301)
        expect(response.location).to eq(root_url)
      end

    end

  end

end
