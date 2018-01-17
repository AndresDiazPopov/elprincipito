require "rails_helper"

describe Logins::Deny do

  subject { Logins::Deny }

  context 'when an requested login exists' do

    let(:login) { create(:login, state: :requested) }

    describe 'call' do

      it 'denies the login' do
        subject.call(login: login, denied_reason: Faker::Lorem.word)
        expect(login).to have_state(:denied)
      end

    end

  end

  context 'when an denied login exists' do

    let(:login) { create(:login, state: :denied, denied_reason: Faker::Lorem.word) }

    describe 'call' do

      it 'does nothing with the login' do
        subject.call(login: login, denied_reason: Faker::Lorem.word)
        expect(login).to have_state(:denied)
      end

    end

  end

end