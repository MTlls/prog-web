class AddColumnToLivros < ActiveRecord::Migration[7.1]
  def change
    add_column :livros, :emprestados, :integer
  end
end
