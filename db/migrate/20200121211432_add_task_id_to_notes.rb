class AddTaskIdToNotes < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :task_id, :integer
  end
end
