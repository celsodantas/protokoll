class AddScopeByToCustomAutoIncrements < ActiveRecord::Migration
  def up
    add_column :custom_auto_increments, :counter_model_scope, :string
    add_index :custom_auto_increments, [:counter_model_name, :counter_model_scope],
              :unique => true, :name => :counter_model_name_scope
  end

  def down
    remove_index :custom_auto_increments, name: :counter_model_name_scope
    remove_column :custom_auto_increments, :counter_model_scope, :string
  end
end
