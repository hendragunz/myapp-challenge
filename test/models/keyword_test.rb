require "test_helper"

class KeywordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
#  processed_at         :datetime
#
