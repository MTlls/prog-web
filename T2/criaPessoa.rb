require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
:database => "Biblioteca.sqlite3"

ActiveRecord::Base.connection.create_table :pessoas do |t|
    t.string :nome
    t.integer :cpf
    t.string :email
    t.string :telefone
    t.string :endereco
end
