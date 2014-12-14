require 'rails_helper'

RSpec.describe 'Admin' do
  subject { page }

  describe 'accessing root page should display admin signin' do

    before do
      visit '/'
      save_and_open_page
    end

    it { should have_content 'You need to sign in or sign up before continuing.' }
  end
end