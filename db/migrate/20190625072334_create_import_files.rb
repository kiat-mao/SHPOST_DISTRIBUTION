class CreateImportFiles < ActiveRecord::Migration
  def change
    create_table :import_files do |t|
      t.string :file_name, null: false
      t.string :file_path, null: false, default: ''
      t.integer :user_id
      t.integer :unit_id
      t.integer :symbol_id
      t.string :symbol_type
      t.string :size
      t.string :category
      t.string :file_ext
      t.string :desc, :limit => 200

      t.timestamps
    end
  end
end
