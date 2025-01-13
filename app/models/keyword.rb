class Keyword < ApplicationRecord

  belongs_to :user

  scope :ascending, -> { order(name: :asc) }

  # callbacks before validations
  #
  before_validation :strip_name

  # validations
  #
  validates :name,  presence: true,
                    uniqueness: { case_sensitive: false }

  private

  def strip_name
    self.name = name.to_s.strip.downcase
  end
end

# == Schema Information
#
# Table name: keywords
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  total_adwords        :integer
#  total_links          :integer
#  total_search_results :string
#  html_page            :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint
#
