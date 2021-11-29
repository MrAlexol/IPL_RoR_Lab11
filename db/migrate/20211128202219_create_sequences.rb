class CreateSequences < ActiveRecord::Migration[6.1]
  def change
    create_table :sequences do |t|
      t.string :values
      t.text :output

      t.timestamps
    end
    add_index :sequences, :values
  end
end
