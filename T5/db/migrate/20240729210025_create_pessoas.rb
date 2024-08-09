class CreatePessoas < ActiveRecord::Migration[7.1]
  def change
    create_table :pessoas do |t|
      t.string :nome, null: false
      t.integer :cpf, null: false
      t.string :email, null: false
      t.string :telefone, null: false
      t.string :endereco, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
