require 'faker'
Faker::Config.locale = 'pt-BR'

# um admin
Pessoa.create!(
  nome: 'Admin',
  cpf: 00000000000,
  email: 'admin@example.com',
  telefone: '000000000',
  endereco: 'Rua Exemplo, 123',
  password: 'adminadmin',
  privilegio: 1
)

# Populando autores
10.times do
  Autor.create!(
    nome: Faker::Book.author,
    nacionalidade: Faker::Address.country
  )
end

# Populando livros
autores = Autor.all
20.times do
  Livro.create!(
    titulo: Faker::Book.title,
    ano: Faker::Number.between(from: 1900, to: 2023).to_s,
    genero: Faker::Book.genre,
    quantidade: Faker::Number.between(from: 1, to: 10),
    autor: autores.sample,
    emprestados: Faker::Number.between(from: 0, to: 10)
  )
end

# Populando pessoas
10.times do
  Pessoa.create!(
    nome: Faker::Name.name,
    cpf: Faker::Number.number(digits: 11),
    email: Faker::Internet.email,
    telefone: Faker::PhoneNumber.phone_number,
    endereco: Faker::Address.full_address,
    password: 'password',
    privilegio: Faker::Number.between(from: 0, to: 1)
  )
end

# Populando carteirinhas
pessoas = Pessoa.all
pessoas.each do |pessoa|
  Carteirinha.create!(
    podeEmprestar: [true, false].sample,
    pessoa: pessoa
  )
end

# Populando relacionamentos carteirinhas_livros, impedindo emprestimos de livros não disponíveis
carteirinhas = Carteirinha.all
livros = Livro.all
carteirinhas.each do |carteirinha|
  rand(1..3).times do
    livro = livros.sample
    if livro.quantidade - livro.emprestados > 0
      livro.emprestados += 1
      livro.save
      CarteirinhasLivro.create!(
        carteirinha: carteirinha,
        livro: livro,
        data_emprestimo: Faker::Date.backward(days: 30),
        data_devolucao: Faker::Date.forward(days: 30)
      )
    else 
      next
    end
  end
end
