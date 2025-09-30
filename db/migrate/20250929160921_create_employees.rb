class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees, id: :uuid do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :position, null: false
      t.integer :status, default: 0
      t.timestamp :deleted_at
      t.timestamps
    end

    add_index :employees, :email, unique: true
    add_index :employees, :status
    add_index :employees, :deleted_at
    add_index :employees, :position
  end
end
