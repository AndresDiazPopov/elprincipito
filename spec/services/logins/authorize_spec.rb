require "rails_helper"

describe Logins::Authorize do

  subject { Logins::Authorize }

  context 'when an requested login exists' do

    let(:login) { create(:login, state: :requested) }

    describe 'call' do

      it 'authorizes the login' do
        subject.call(login: login)
        expect(login).to have_state(:authorized)
      end

    end

  end

  context 'when an authorized login exists' do

    let(:login) { create(:login, state: :authorized) }

    describe 'call' do

      it 'does nothing with the login' do
        subject.call(login: login)
        expect(login).to have_state(:authorized)
      end

    end

  end

end