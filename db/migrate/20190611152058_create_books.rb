class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :name
      t.string :status
      t.integer :word_count

      t.timestamps
    end
  end
end
