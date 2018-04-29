class CreateWildNewsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :wild_news do |t|
      t.text :text
      t.string :link
      t.integer :subject_id

      t.timestamps
    end
  end
end
