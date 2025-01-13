class CreateKeywords < ActiveRecord::Migration[7.2]
  def change
    create_table :keywords do |t|
      t.string  :name
      t.integer :total_adwords
      t.integer :total_links
      t.string  :total_search_results # Yes, this is string not number/integer
      t.text    :html_page
      t.timestamps
    end
  end
end
