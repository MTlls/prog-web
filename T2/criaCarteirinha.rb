require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
:database => "Biblioteca.sqlite3"

ActiveRecord::Base.connection.create_table :carteirinhas do |t|
    t.boolean :podeEmprestar
    t.references :pessoa, foreign_key: true
end
