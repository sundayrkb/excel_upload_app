class User < ApplicationRecord
  validates :first_name, :last_name, presence: true
  # validates_format_of :first_name, :last_name, with: /\A[a-zA-Z]+\z/, message: "can only contain letters"
  validates :email_id, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
