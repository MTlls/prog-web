$:.push './'
require 'active_record'
require 'autor.rb'
require 'pessoa.rb'
require 'carteirinha.rb'
require 'livro.rb'

# Crie autores
machado_de_assis = Autor.new({nome: "Machado de Assis", nacionalidade: "Brasileira"})
clarice_lispector = Autor.new({nome: "Clarice Lispector", nacionalidade: "Brasileira"})

puts "\nautor1: \nnome : #{machado_de_assis.nome}\n"
puts "nacionalidade #{machado_de_assis.nacionalidade}\n"

puts "autor2:\nnome : #{clarice_lispector.nome}\n"
puts "nacionalidade \n#{clarice_lispector.nacionalidade}\n\n"
machado_de_assis.save
clarice_lispector.save

# Crie pessoas
pessoa1 = Pessoa.new({nome: "Pessoa 1", cpf: 12345678901, email: "pessoa1@example.com", telefone: "123456789", endereco: "Endereço 1"})
pessoa2 = Pessoa.new({nome: "Pessoa 2", cpf: 23456789012, email: "pessoa2@example.com", telefone: "234567890", endereco: "Endereço 2"})
pessoa1.save
pessoa2.save
puts "pessoa1: \nnome : #{pessoa1.nome}\n"
puts "cpf: #{pessoa1.cpf}\n"
puts "email: #{pessoa1.email}\n"
puts "telefone: #{pessoa1.telefone}\n"
puts "endereco: #{pessoa1.endereco}\n"

puts "pessoa2: \nnome : #{pessoa2.nome}\n"
puts "cpf: #{pessoa2.cpf}\n"
puts "email: #{pessoa2.email}\n"
puts "telefone: #{pessoa2.telefone}\n"
puts "endereco: #{pessoa2.endereco}\n\n"

# Crie carteiras de biblioteca
carteira1 = Carteirinha.new({pessoa: pessoa1, podeEmprestar: true})
carteira2 = Carteirinha.new({pessoa: pessoa2, podeEmprestar: false})
carteira1.save
carteira2.save

# Imprime carteiras
puts "carteira1: \npessoa: #{carteira1.pessoa.nome}\n"
puts "podeEmprestar: #{carteira1.podeEmprestar}\n"

puts "carteira2: \npessoa: #{carteira2.pessoa.nome}\n"
puts "podeEmprestar: #{carteira2.podeEmprestar}\n\n"

# Crie livros
livro1 = Livro.new({titulo: "Dom Casmurro", ano: "Ano 1", genero: "Romance", quantidade: 1, emprestados: 1, autor: machado_de_assis})
livro2 = Livro.new({titulo: "Memórias Póstumas de Brás Cubas", ano: "Ano 2", genero: "Romance", quantidade: 1, emprestados: 1, autor: machado_de_assis})
livro3 = Livro.new({titulo: "A Hora da Estrela", ano: "Ano 3", genero: "Romance", quantidade: 1, emprestados: 1, autor: clarice_lispector})

livro1.save
livro2.save
livro3.save

# Imprime livros
puts "livro1: \ntitulo: #{livro1.titulo}\n"
puts "ano: #{livro1.ano}\n"
puts "genero: #{livro1.genero}\n"
puts "quantidade: #{livro1.quantidade}\n"
puts "autor: #{livro1.autor.nome}\n"

puts "livro2: \ntitulo: #{livro2.titulo}\n"
puts "ano: #{livro2.ano}\n"
puts "genero: #{livro2.genero}\n"
puts "quantidade: #{livro2.quantidade}\n"
puts "autor: #{livro2.autor.nome}\n\n"

# Associe livros às carteiras
livro1.carteirinhas << carteira1
livro1.carteirinhas << carteira1
livro2.carteirinhas << carteira1
livro3.carteirinhas << carteira2

# Imprime livros associados a cada carteira
puts "livros associados a cada carteira 1: \n"
carteira1.livros.each do |livro|
    puts "carteira1: #{livro.titulo}\n"
end

puts "livros associados a cada carteira 2: \n"
carteira2.livros.each do |livro|
    puts "carteira2: #{livro.titulo}\n\n"
end

# Imprime os livros de cada autor
puts "livros de #{machado_de_assis.nome}: \n"
machado_de_assis.livros.each do |livro|
    puts "#{livro.titulo}\n"
end
puts "livros de #{clarice_lispector.nome}: \n"
clarice_lispector.livros.each do |livro|
    puts "#{livro.titulo}\n"
end

# Imprime os autores de cada livro
puts "autor de #{livro1.titulo}: \n"
puts "#{livro1.autor.nome}\n"

puts "autor de #{livro2.titulo}: \n"
puts "#{livro2.autor.nome}\n"

puts "autora de #{livro3.titulo}: \n"
puts "#{livro3.autor.nome}\n"

