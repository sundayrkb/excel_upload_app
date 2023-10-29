require 'rails_helper'

RSpec.feature 'User Management', type: :feature do
  scenario 'User views the list of users' do
    FactoryBot.create(:user, first_name: 'Ravi', last_name: 'Kumar', email: 'rk@email.com')

    visit users_path

    expect(page).to have_content('Users: 1')
    expect(page).to have_content('Ravi')
    expect(page).to have_content('Kumar')
    expect(page).to have_content('rk@email.com')
  end
end
