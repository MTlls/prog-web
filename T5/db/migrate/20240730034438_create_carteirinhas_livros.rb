class CreateCarteirinhasLivros < ActiveRecord::Migration[7.1]
  def change
    create_table :carteirinhas_livros do |t|
      t.references :carteirinha, null: false, foreign_key: true
      t.references :livro, null: false, foreign_key: true

      t.timestamps
    end
  end
end
