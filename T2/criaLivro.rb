require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
:database => "Biblioteca.sqlite3"

ActiveRecord::Base.connection.create_table :livros do |t|
    t.string :titulo
    t.string :ano
    t.string :genero
    t.integer :quantidade
    t.belongs_to :autor, foreign_key: true, null: false
end