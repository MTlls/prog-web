# test/models/livro_test.rb
require "test_helper"

class LivroTest < ActiveSupport::TestCase
  # Teste se o modelo é válido com os atributos corretos
  test "should be valid" do
    livro = Livro.new(titulo: "Título Exemplo", ano: 2024, genero: "Ficção", quantidade: 5, emprestados: 0, autor_id: autors(:one).id)
    assert livro.valid?
  end

  # Teste para verificar a presença do título
  test "should not be valid without titulo" do
    livro = Livro.new(ano: 2024, genero: "Ficção", quantidade: 5, emprestados: 0, autor_id: autors(:one).id)
    assert_not livro.valid?
  end

  # Teste para verificar a presença do ano
  test "should not be valid without ano" do
    livro = Livro.new(titulo: "Título Exemplo", genero: "Ficção", quantidade: 5, emprestados: 0, autor_id: autors(:one).id)
    assert_not livro.valid?
  end

    # Teste para verificar a presença do autor
  test "should not be valid without autor" do
    livro = Livro.new(titulo: "Título Exemplo", genero: "Ficção", quantidade: 5, emprestados: 0)
    assert_not livro.valid?
  end

  test "should not be valid without genero" do
    livro = Livro.new(titulo: "Título Exemplo", ano: 2024, quantidade: 5, emprestados: 0, autor_id: autors(:one).id)
    assert_not livro.valid?
  end

  # Teste de associação com autor
  test "should belong to autor" do
    livro = livros(:one) # Supondo que você tenha um fixture
    assert_respond_to livro, :autor
  end

  # Teste de associação com carteirinhas
  test "should have many carteirinhas" do
    livro = livros(:one) # Supondo que você tenha um fixture
    assert_respond_to livro, :carteirinhas
  end
end
