class CreateProtocols < ActiveRecord::Migration[4.2]
  def change
    create_table :protocols do |t|
      t.string :number
      t.string :context
      t.string :context_2

      t.timestamps
    end
  end
end
