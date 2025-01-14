class AddProcessedAtToKeywords < ActiveRecord::Migration[7.2]
  def change
    add_column :keywords, :processed_at, :datetime
  end
end
