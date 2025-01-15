require 'rails_helper'

RSpec.describe Keyword, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:user_id) }
  end

end
