class CreatePrincipals < ActiveRecord::Migration
  def change
    create_table :principals do |t|
      t.string :number_format

      t.timestamps
    end
  end
end
