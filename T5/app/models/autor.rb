class Autor < ApplicationRecord
  validates :nome, presence: true
  validates :nacionalidade, presence: true, length: { minimum: 2 }
  has_many :livros, dependent: :destroy

  scope :search, ->(query) {
    where('nome LIKE ?', "%#{query}%")
  }
end
