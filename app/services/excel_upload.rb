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
    header = spreadsheet.row(1).map(&:downcase)

    required_headers = ['first_name', 'last_name', 'email_id']

    missing_headers = required_headers - header

    return { error: "Missing headers: #{missing_headers.join(', ')}" } if missing_headers.any?

    unknown_headers = header - required_headers

    return { error: "Unknown headers: #{unknown_headers.join(', ')}" } if unknown_headers.any?

    user_attributes = []
    (2..@total_rows).each do |index|
      row = Hash[header.zip(spreadsheet.row(index))]
      user_attributes << row
    end

    columns = user_attributes.first.keys
    users_to_insert = user_attributes.map { |attributes| User.new(attributes) }

    User.import(columns, users_to_insert, validate: true)

    users_to_insert.each_with_index do |user, index|
      if user.errors.present?
        @failures << { index: index + 2, errors: user.errors.full_messages }
      else
        @success_count+=1
      end
    end

    { total_rows: @total_rows-1, success_count: @success_count, failures: @failures }
  end
end
