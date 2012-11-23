class CreateCustomAutoIncrements < ActiveRecord::Migration
  def up
    create_table :custom_auto_increments, :force => true do |t|
      t.string  :model_name
      t.integer :counter, :default => 0
      t.timestamps
    end
    
    add_index :custom_auto_increments, :model_name
  end

  def down
    drop_table :custom_auto_increments
  end
end