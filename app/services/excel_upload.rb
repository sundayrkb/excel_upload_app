class ExcelUpload
  def initialize(file)
    @file = file
    @success_count = 0
    @failures = []
    @total_rows = 0
  end

  def process
    spreadsheet = Roo::Spreadsheet.open(@file.path)

    @total_rows = spreadsheet.last_row
    header = spreadsheet.row(1).map { |header| header.downcase.to_sym } # Convert headers to lowercase symbols

    (2..@total_rows).each do |index|
      row = Hash[header.zip(spreadsheet.row(index))]
      user = User.find_or_initialize_by(row)
      if user.update(row)
        @success_count += 1
      else
        @failures << { index: index + 1, errors: user.errors.full_messages }
      end
    end

    { total_rows: @total_rows-1, success_count: @success_count, failures: @failures } #removed header count
  end
end
