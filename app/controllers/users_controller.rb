class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(5)
    @result = flash[:result]
  end

  def import
    file = params[:file]
    return redirect_to users_path, notice: 'Please upload a file' if file.nil?

    @result = ExcelUpload.new(file).process
    flash[:result] = @result
    if @result[:error].present?
      redirect_to users_path, alert: @result[:error]
    else
      redirect_to users_path, notice: 'Users imported!'
    end
  end
end
