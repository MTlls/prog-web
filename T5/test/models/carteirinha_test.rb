# test/models/carteirinha_test.rb
require "test_helper"

class CarteirinhaTest < ActiveSupport::TestCase
  # Teste se o modelo é válido com os atributos corretos
  test "should be valid" do
    carteirinha = Carteirinha.new(pessoa: pessoas(:one), podeEmprestar: true)
    assert carteirinha.valid?
  end

  # Teste para verificar a presença de podeEmprestar
  test "should not be valid without podeEmprestar" do
    carteirinha = Carteirinha.new
    assert_not carteirinha.valid?
  end

  # Teste para verificar a presença de podeEmprestar
  test "should not be valid without pessoa" do
    carteirinha = Carteirinha.new(podeEmprestar: true)
    assert_not carteirinha.valid?
  end

  test "should belong to pessoa" do
    carteirinha = Carteirinha.new(podeEmprestar: true)
    assert_respond_to carteirinha, :pessoa
  end
  
  test "should have many livros" do
    carteirinha = carteirinhas(:one)
    assert_respond_to carteirinha, :livros
  end
end
