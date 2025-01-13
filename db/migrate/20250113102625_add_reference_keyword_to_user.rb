class AddReferenceKeywordToUser < ActiveRecord::Migration[7.2]
  def change
    add_reference :keywords, :user, index: true
  end
end
