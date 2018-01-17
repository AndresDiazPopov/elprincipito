require "rails_helper"

describe AdminRoles::Delete do

  subject { AdminRoles::Delete }

  # Repito el test para cada rol
  AdminRole.roles.each do |role|

    role = role[0].to_sym

    context 'when an admin_user exist' do
      
      before(:each) do
        @admin_user = create(:admin_user)
        @admin_user.has_role!(role)
        @authorizable_id = nil
      end

      it 'deletes the admin_role if exists' do
        subject.call(admin_user: @admin_user, role: role, authorizable_id: @authorizable_id)
        expect(@admin_user.reload.has_role?(role)).to be_falsy
      end

      it 'does not fail when role does not exist' do
        subject.call(admin_user: @admin_user, role: Faker::Lorem.word, authorizable_id: @authorizable_id)
        expect(@admin_user.reload.has_role?(role)).to be_truthy
      end

      it 'sends the role_deleted mail to the admin' do
        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(0)
        subject.call(admin_user: @admin_user, role: role, authorizable_id: @authorizable_id)
        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
      end

    end

  end

end