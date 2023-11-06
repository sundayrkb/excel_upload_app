require 'rails_helper'

RSpec.describe 'users/_import_result', type: :view do
  let(:result) do
    {
      "total_rows" => 10,
      "success_count" => 7,
      "failures" => [
        { "index" => 7, "errors" => ["First name can't be blank", "Email is invalid"] },
        { "index" => 9, "errors" => ["First name can't be blank"] },
        { "index" => 12, "errors" => ["Last name can't be blank", "Email is invalid"] }
      ]
    }
  end

  it 'displays the import result' do
    assign(:result, result)
    render

    expect(rendered).to have_content('Upload Results:')
    expect(rendered).to have_content('Total User Data Rows: 10')
    expect(rendered).to have_content('Successfully Added: 7')
    expect(rendered).to have_content('Failed: 3')

    expect(rendered).to have_content('Failure Details:')
    expect(rendered).to have_content('Row 7: First name can\'t be blank, Email is invalid')
    expect(rendered).to have_content('Row 9: First name can\'t be blank')
    expect(rendered).to have_content('Row 12: Last name can\'t be blank, Email is invalid')
  end
end
