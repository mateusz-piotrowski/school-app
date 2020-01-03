require 'rails_helper'

RSpec.feature 'User deletes the account' do
  subject { page }

  let(:user) { create :user }

  background do
    sign_in user
    visit edit_user_registration_path
  end

  scenario 'successfully', js: true do
    expect {
      accept_confirm { click_link 'Usuń' }
      sleep 0.1
    }.to change(User, :count).by(-1)

    is_expected.to have_success_message
  end
end
