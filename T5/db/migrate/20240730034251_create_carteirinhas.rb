class CreateCarteirinhas < ActiveRecord::Migration[7.1]
  def change
    create_table :carteirinhas do |t|
      t.boolean :podeEmprestar, null: false
      t.references :pessoa, null: false, foreign_key: true

      t.timestamps
    end
  end
end
