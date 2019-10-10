class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :name
      t.string :status
      t.integer :word_count
      t.string :session_key

      t.timestamps
    end
  end
end
