# test/models/autor_test.rb
require "test_helper"

class AutorTest < ActiveSupport::TestCase
  # Teste se o modelo é válido com os atributos corretos
  test "should be valid" do
    autor = Autor.new(nome: "Autor Exemplo", nacionalidade: "Brasileira")
    autor.save
    assert autor.valid?
  end

  # Teste para verificar a presença do nome
  test "should not be valid without nome" do
    autor = Autor.new(nacionalidade: "Brasileira")
    assert_not autor.valid?
  end

  # Teste para verificar a presença da nacionalidade
  test "should not be valid without nacionalidade" do
    autor = Autor.new(nome: "Autor Exemplo")
    assert_not autor.valid?
  end

  # Teste de associação com livros
  test "should have many livros" do
    autor = autors(:one) # Supondo que você tenha um fixture
    assert_respond_to autor, :livros
  end
end
