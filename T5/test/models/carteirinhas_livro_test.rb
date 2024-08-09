# test/models/carteirinhas_livro_test.rb
require "test_helper"

class CarteirinhasLivroTest < ActiveSupport::TestCase
  # Teste se o modelo é válido com os atributos corretos
  test "should be valid" do
    carteirinhas_livro = CarteirinhasLivro.new(carteirinhas_livros(:one).attributes)
    assert carteirinhas_livro.valid?
  end

  # Teste para verificar a presença de livro_id
  test "should not be valid without livro_id" do
    carteirinhas_livro = CarteirinhasLivro.new(
      carteirinha_id: carteirinhas(:one).id,
      data_emprestimo: Time.now
    )
    assert_not carteirinhas_livro.valid?
  end

  # Teste para verificar a presença de carteirinha_id
  test "should not be valid without carteirinha_id" do
    carteirinhas_livro = CarteirinhasLivro.new(
      livro_id: livros(:one).id,
      data_emprestimo: Time.now
    )
    assert_not carteirinhas_livro.valid?
  end

  # Teste de associações
  test "should belong to livro" do
    carteirinhas_livro = carteirinhas_livros(:one) # Supondo que você tenha um fixture
    assert_respond_to carteirinhas_livro, :livro
  end

  test "should belong to carteirinha" do
    carteirinhas_livro = carteirinhas_livros(:one) # Supondo que você tenha um fixture
    assert_respond_to carteirinhas_livro, :carteirinha
  end
end
