class Livro < ApplicationRecord
  validates :titulo, presence: true, length: { maximum: 70 }
  validates :ano, presence: true, length: { maximum: 4 }
  validates :genero, presence: true, length: { maximum: 40 }
  validates :quantidade, presence: true, numericality: { only_integer: true }
  validates :emprestados, presence: true, numericality: { only_integer: true }
  belongs_to :autor
  has_and_belongs_to_many :carteirinhas

  scope :search, ->(query) {
    where('titulo LIKE ?', "%#{query}%")
  }
end
