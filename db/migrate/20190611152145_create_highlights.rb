class CreateHighlights < ActiveRecord::Migration[5.2]
  def change
    create_table :highlights do |t|
      t.string :content
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
