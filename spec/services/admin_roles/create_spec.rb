require "rails_helper"

describe AdminRoles::Create do

  subject { AdminRoles::Create }

  # Repito el test para cada rol
  AdminRole.roles.each do |role|

    role = role[0].to_sym

    context 'when an admin_user exist' do
      
      before(:each) do
        @admin_user = create(:admin_user)
        @authorizable_type = nil
        @authorizable_id = nil
      end

      it 'creates the role' do
        subject.call(admin_user: @admin_user, role: role, authorizable_type: @authorizable_type, authorizable_id: @authorizable_id)
        expect(@admin_user.reload.has_role?(role)).to be_truthy
      end

      it 'sends the welcome mail to the admin' do
        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(0)
        subject.call(admin_user: @admin_user, role: role, authorizable_type: @authorizable_type, authorizable_id: @authorizable_id)
        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
      end

      it 'does not send the welcome mail to the admin if specified' do
        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(0)
        subject.call(admin_user: @admin_user, role: role, authorizable_type: @authorizable_type, authorizable_id: @authorizable_id, skip_confirmation: true)
        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(0)
      end

    end

  end

end