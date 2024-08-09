class CreateAutors < ActiveRecord::Migration[7.1]
  def change
    create_table :autors do |t|
      t.string :nome, null: false
      t.string :nacionalidade, null: false

      t.timestamps
    end
  end
end
