require "rails_helper"

describe Users::Update do

  subject { Users::Update }

  context 'when a user exists' do
    
    before(:each) do
      @user = create(:user)
    end

    describe 'call' do

      it 'changes password when passing valid old_password' do
        old_password = @user.password
        password = Faker::Internet.password(8)
        subject.call(
          user: @user,
          old_password: @user.password,
          new_password: password)
        expect(@user.reload.valid_password?(old_password)).to be_falsy
        expect(@user.reload.valid_password?(password)).to be_truthy
      end

      it 'raises Exceptions::UnauthorizedError when passing wrong old_password' do
        expect{
          subject.call(
            user: @user,
            old_password: Faker::Internet.password(8),
            new_password: Faker::Internet.password(8))
          }.to raise_error(Exceptions::UnauthorizedError)
      end

      context 'when user has no image' do

        it 'sets the user image when passing a valid file' do
          expect{
            subject.call(
              user: @user,
              image: File.new("#{Rails.root}/spec/support/default.jpg"))
            }.to change{@user.reload.image.exists?}.from(false).to(true)
          expect(have_attached_file(:image)).to be_truthy
        end

      end

      context 'when user has no image' do

        it 'sets the user image when passing a valid image_url' do
          expect{
            subject.call(
              user: @user,
              image_url: 'https://fakeimg.pl/100/')
            }.to change{@user.reload.image.exists?}.from(false).to(true)
          expect(have_attached_file(:image)).to be_truthy
        end

      end

    end

  end

end