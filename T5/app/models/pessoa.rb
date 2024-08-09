class Pessoa < ApplicationRecord
    validates :nome, presence: true, length: { maximum: 70 }
    validates :cpf, presence: true, length: { maximum: 11 }, uniqueness: true, numericality: { only_integer: true }
    validates :email, presence: true, length: { maximum: 70 }, uniqueness: true
    validates :telefone, presence: true
    validates :endereco, presence: true, length: { maximum: 150 }
    validates :password, length: { minimum: 6, allow_blank: true }
    has_secure_password

    has_one :carteirinha, dependent: :destroy
    enum privilegio: { comum: 0, admin: 1 }
    def password_present?
        password.present?
    end
end
