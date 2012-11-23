class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :registry_number

      t.timestamps
    end
  end
end
