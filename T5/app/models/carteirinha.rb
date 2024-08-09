class Carteirinha < ApplicationRecord
  belongs_to :pessoa
  has_and_belongs_to_many :livros, dependent: :destroy
  validates :podeEmprestar, inclusion: { in: [true, false] }
end
