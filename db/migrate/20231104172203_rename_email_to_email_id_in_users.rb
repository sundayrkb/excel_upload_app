class RenameEmailToEmailIdInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :email, :email_id
  end
end
