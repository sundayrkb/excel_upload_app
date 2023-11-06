require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #import' do

    let(:file_path) { Rails.root.join('tmp', 'sample_sheet.xlsx') }
    let(:missing_header_file_path) { Rails.root.join('tmp/missing_header.xlsx') }
    let(:unknown_header_file_path) { Rails.root.join('tmp/unknown_header.xlsx') }
    let(:sample_file) { fixture_file_upload(file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
    let(:missing_header_file) { fixture_file_upload(missing_header_file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
    let(:unknown_header_file) { fixture_file_upload(unknown_header_file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }

    context 'when no file is provided' do
      it 'redirects to users_path with a notice' do
        post :import
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq('Please upload a file')
      end
    end

    context 'with missing headers' do
      it 'redirects to users_path with an error notice' do
        post :import, params: { file: missing_header_file }

        expect(response).to redirect_to(users_path)
        expect(flash[:alert]).to match(/Missing headers: email_id/i)
      end
    end

    context 'with unknown headers' do
      it 'redirects to users_path with an error notice' do
        post :import, params: { file: unknown_header_file }

        expect(response).to redirect_to(users_path)
        expect(flash[:alert]).to match(/Unknown headers: phone_no/i)
      end
    end

    context 'with valid headers' do
      it 'redirects to users_path with a success notice' do
        post :import, params: { file: sample_file }

        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to match(/Users imported!/i)
      end
    end
  end
end
