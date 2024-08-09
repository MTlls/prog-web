class CarteirinhasLivro < ApplicationRecord
  belongs_to :livro
  belongs_to :carteirinha 
  validates :data_emprestimo, presence: true
  validates :data_devolucao, presence: true
end
