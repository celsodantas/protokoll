class CreateCalls < ActiveRecord::Migration[4.2]
  def change
    create_table :calls do |t|
      t.string :number
      t.timestamps
    end
  end
end
