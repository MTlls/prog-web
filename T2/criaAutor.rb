require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
:database => "Biblioteca.sqlite3"

ActiveRecord::Base.connection.create_table :autors do |t|
    t.string :nome
    t.string :nacionalidade
end
