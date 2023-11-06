require 'rails_helper'

RSpec.describe ExcelUpload do
  describe '#process' do
    let(:file_path) { Rails.root.join('tmp/sample_sheet.xlsx') }
    let(:missing_header_file_path) { Rails.root.join('tmp/missing_header.xlsx') }
    let(:unknown_header_file_path) { Rails.root.join('tmp/unknown_header.xlsx') }
    let(:sample_file) { fixture_file_upload(file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
    let(:missing_header_file) { fixture_file_upload(missing_header_file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
    let(:unknown_header_file) { fixture_file_upload(unknown_header_file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }

    context 'with missing headers' do
      it 'returns an error indicating missing headers' do
        result = ExcelUpload.new(missing_header_file).process

        expect(result).to include(error: /Missing headers: email_id/i)
        expect(result[:total_rows]).to be_nil
        expect(result[:success_count]).to be_nil
        expect(result[:failures]).to be_nil
      end
    end

    context 'with unknown headers' do
      it 'returns an error indicating unknown headers' do
        result = ExcelUpload.new(unknown_header_file).process

        expect(result).to include(error: /Unknown headers: phone_no/i)
        expect(result[:total_rows]).to be_nil
        expect(result[:success_count]).to be_nil
        expect(result[:failures]).to be_nil
      end
    end

    context 'with valid headers' do
      it 'processes the file successfully' do
        result = ExcelUpload.new(sample_file).process

        expect(result[:error]).to be_nil
        expect(result[:total_rows]).to be_present
        expect(result[:success_count]).to be_present
        expect(result[:failures]).to be_present
      end
    end
  end
end
