require "rails_helper"

describe AdminUsers::UpdatePassword do

  subject { AdminUsers::UpdatePassword }

  let(:password) { Faker::Internet.password }
  let(:new_password) { Faker::Internet.password }
  let(:admin_user) { create(:admin_user, password: password) }

  describe 'call' do

    it 'updates the password' do
      subject.call(admin_user: admin_user,
        admin_user_params: {
          current_password: password,
          password: new_password,
          password_confirmation: new_password
        })
      expect(admin_user.valid_password?(new_password)).to be_truthy
    end

    it 'does not update the password if current_password is invalid' do
      subject.call(admin_user: admin_user,
        admin_user_params: {
          current_password: Faker::Internet.password,
          password: new_password,
          password_confirmation: new_password,
        })
      expect(admin_user.valid_password?(new_password)).to be_falsy
    end

    it 'does not update the password if password and password_confirmation do not match' do
      subject.call(admin_user: admin_user,
        admin_user_params: {
          current_password: password,
          password: Faker::Internet.password,
          password_confirmation: new_password,
        })
      expect(admin_user.valid_password?(new_password)).to be_falsy
    end

  end

end