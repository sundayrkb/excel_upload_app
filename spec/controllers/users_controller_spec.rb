require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #import' do
    context 'when no file is provided' do
      it 'redirects to users_path with a notice' do
        post :import
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq('Please upload a file')
      end
    end

    context 'when a file is provided' do
      let(:file_path) { Rails.root.join('tmp', 'sample_sheet.xlsx') }
      let(:file) { fixture_file_upload(file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }

      it 'imports users and redirects to users_path with a success notice' do
        expect do
          post :import, params: { file: file }
        end.to change(User, :count)

        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq('Users imported!')
      end
    end
  end
end
