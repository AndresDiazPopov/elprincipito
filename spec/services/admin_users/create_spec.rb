require "rails_helper"

describe AdminUsers::Create do

  subject { AdminUsers::Create }

  describe 'call' do

    it 'creates a valid admin admin_user' do
      email = Faker::Internet.email
      expect(
        subject.call(admin_user_params: {
          email: email,
          full_name: Faker::Name.name},
          role: :admin)
        ).to eq(AdminUser.find_by(email: email))
    end

    it 'assigns the admin role to the admin_user' do
      admin_user = subject.call(admin_user_params: {
        email: Faker::Internet.email,
        full_name: Faker::Name.name},
        role: :admin)
      expect(admin_user.roles.count).to eq(1)
    end

    it 'sends the welcome mail to the admin' do
      expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(0)
      subject.call(admin_user_params: {
        email: Faker::Internet.email,
        full_name: Faker::Name.name},
        role: :admin)
      expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
    end

  end

end