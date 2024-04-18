require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
:database => "Biblioteca.sqlite3"

ActiveRecord::Base.connection.create_table :carteirinhas_livros, id: false do |t|
    t.references :carteirinha, foreign_key: true
    t.references :livro, foreign_key: true
end
