class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :token_authenticatable

  has_many :keywords, dependent: :destroy

  validates :first_name,  presence: true
  validates :last_name,   presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.authenticate!(email, password)
    user = find_by(email: email.downcase)
    user if user&.valid_password?(password)
  end
end

# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  email                           :string           default(""), not null
#  encrypted_password              :string           default(""), not null
#  reset_password_token            :string
#  reset_password_sent_at          :datetime
#  remember_created_at             :datetime
#  first_name                      :string           not null
#  last_name                       :string           not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  authentication_token            :text
#  authentication_token_created_at :datetime
#
