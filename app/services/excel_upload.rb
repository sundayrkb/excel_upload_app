class ExcelUpload
  def initialize(file)
    @file = file
    @success_count = 0
    @failures = []
    @total_rows = 0
  end

  def process
    spreadsheet = Roo::Spreadsheet.open(@file.path)

    @total_rows = spreadsheet.last_row - 1 # remove the header count

    spreadsheet.each_with_index(first_name: 'FIRST_NAME', last_name: 'LAST_NAME', email: 'EMAIL_ID' ) do |row, index|
      next if index.zero?  # Skip header

      user = User.find_or_initialize_by(row)
      if user.save
        @success_count += 1
      else
        @failures << { index: index + 1, errors: user.errors.full_messages }
      end
    end

    { total_rows: @total_rows, success_count: @success_count, failures: @failures }
  end
end
