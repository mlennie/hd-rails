require 'spec_helper'

RSpec.describe 'Admin' do
  subject { page }

  describe 'creating superadmin' do
    before { create(:user, :superadmin) }
    it 'should make a super user' do
      expect(User.count).to be(1)
      expect(Role.count).to be(1)
      expect(User.first.roles.first.name).to eq 'superadmin'
    end
  end

  describe 'Login Page' do
    before { visit '/' }
    it { should have_content 'You need to sign in or sign up before continuing.' }
  end

  describe 'sign in' do
    before do
      create_and_login_admin
    end
    it { should have_content 'Dashboard'}
  end

  describe 'users' do
    describe "accessing users page" do
      before { go_to_users_page }
      it { should have_content 'Displaying all 2 Users'}

      describe 'archiving user' do
        before { archive_user }
        it 'should successfully archive second user and remove from users list' do
          expect(page).to have_content 'You have successfully archived this resource'
          expect(User.first.archived).to be true
          expect(page).to have_content 'Displaying 1 User'
        end
      end
    end
  end
end