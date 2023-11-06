require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  let(:users) { FactoryBot.create_list(:user, 5) }

  before do
    assign(:users, Kaminari.paginate_array(users).page(1).per(5))
    render
  end

  it 'displays a list of users' do
    expect(rendered).to have_selector('h2', text: 'Users: 5')

    expect(rendered).to have_selector('table')
    users.each do |user|
      expect(rendered).to have_content(user.first_name)
      expect(rendered).to have_content(user.last_name)
      expect(rendered).to have_content(user.email_id)
    end
  end
end
