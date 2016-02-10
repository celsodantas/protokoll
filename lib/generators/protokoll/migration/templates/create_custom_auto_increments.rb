class CreateCustomAutoIncrements < ActiveRecord::Migration
  def up
    create_table :custom_auto_increments, :force => true do |t|
      t.string  :counter_model_name
      t.string  :counter_model_scope
      t.integer :counter, :default => 0
      t.timestamps
    end

    add_index :custom_auto_increments, :counter_model_name
    add_index :custom_auto_increments, [:counter_model_name, :counter_model_scope], :unique => true
  end

  def down
    drop_table :custom_auto_increments
  end
end
