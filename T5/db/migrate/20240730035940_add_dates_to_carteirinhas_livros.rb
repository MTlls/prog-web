class AddDatesToCarteirinhasLivros < ActiveRecord::Migration[7.1]
  def change
    add_column :carteirinhas_livros, :data_emprestimo, :datetime
    add_column :carteirinhas_livros, :data_devolucao, :datetime
  end
end
