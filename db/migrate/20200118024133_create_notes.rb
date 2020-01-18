class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.boolean :completed
      t.text :reflect

      t.timestamps
    end
  end
end
