class CreateLivros < ActiveRecord::Migration[7.1]
  def change
    create_table :livros do |t|
      t.string :titulo, null: false
      t.string :ano, null: false
      t.string :genero, null: false
      t.integer :quantidade, null: false
      t.references :autor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
