require 'spec_helper'
module AdminHelper
  def create_and_login_admin
    visit '/'
    admin = create(:user, :superadmin)
    fill_in 'user_email', with: admin.email
    fill_in 'user_password', with: admin.password
    click_button 'Login'
  end

  def go_to_users_page
    create(:user)
    create_and_login_admin
    click_link 'Users'
  end

  def archive_user
    click_link User.first.id.to_s
    click_link 'Delete User'
  end
end