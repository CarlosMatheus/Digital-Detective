class AddTables < ActiveRecord::Migration[5.1]
  def change
    create_table :facts do |t|
      t.string :link
      t.text :text
      t.integer :subject_id
      t.boolean :fake

      t.timestamps
    end

    create_table :news do |t|
      t.text :text
      t.string :link
      t.integer :subject_id

      t.timestamps
    end

    create_table :subjects do |t|
      t.integer :story_id

      t.timestamps
    end

    create_table :stories do |t|
      t.integer :fact_id
      t.integer :new_id

      t.timestamps
    end
  end
end
