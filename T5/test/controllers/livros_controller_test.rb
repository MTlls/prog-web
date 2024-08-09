require "test_helper"
require "faker"
Faker::Config.locale = 'pt-BR'

class LivrosControllerTest < ActionDispatch::IntegrationTest
  include SessionsHelper
  setup do
    @livro = livros(:one) 
    @livros = Livro.all
    @admin = pessoas(:admin) 
    @non_admin = Pessoa.all.excluding(@admin).sample
    @autors = Autor.all
  end

  test "should get index" do
    get livros_url
    assert_response :success
  end

  test "should show livro" do
    get livro_url(@livro)
    assert_response :success
  end

  test "should get new as admin" do
    login_admin(@admin)
    get new_livro_url
    assert_response :success
  end

  test "handle new when not admin" do
    login_user(@non_admin)
    get new_livro_url
    assert_response :unauthorized
  end

  test "should create livro as admin" do
    login_admin(@admin)
    assert_difference("Livro.count") do
      post livros_url, params: { livro: generate_livro }
    end

    assert_redirected_to livro_url(Livro.last)
  end

  test "handle create livro when not admin" do
    login_user(@non_admin)
    assert_no_difference("Livro.count") do
      post livros_url, params: { livro: generate_livro }
    end

    assert_response :unauthorized
  end

  test "should get edit as admin" do
    login_admin(@admin)
    get edit_livro_url(@livro)
    assert_response :success
  end

  test "handle edit when not admin" do
    login_user(@non_admin)
    get edit_livro_url(@livro)
    assert_response :unauthorized
  end

  test "should update livro as admin" do
    login_admin(@admin)
    patch livro_url(@livro), params: { livro: update_ids }
    assert_redirected_to livro_url(@livro)
  end

  test "handle update livro when not admin" do
    login_user(@non_admin)
    patch livro_url(@livro), params:  { livro: update_ids } 
    assert_response :unauthorized
  end

  test "should destroy livro as admin" do
    login_admin(@admin)
    assert_difference("Livro.count", -1) do
      delete livro_url(@livro)
    end

    assert_redirected_to livros_url
  end

  test "handle destroy livro when not admin" do
    login_user(@non_admin)
    assert_no_difference("Livro.count") do
      delete livro_url(@livro)
    end
    assert_response :unauthorized
  end

  def generate_livro
    autor = @autors.sample
    { titulo: Faker::Book.title, autor_id: autor.id, ano: Faker::Number.number(digits: 4), genero: Faker::Book.genre, quantidade: Faker::Number.number(digits: 2), emprestados: Faker::Number.number(digits: 2) }
  end

  def update_ids
    # acha um livro existente e troca o id dele, para que o update seja feito com sucesso
    livro = @livro
    livro = { titulo: Faker::Book.title, autor_id: @autors.sample.id, ano: Faker::Number.number(digits: 4), genero: Faker::Book.genre, quantidade: Faker::Number.number(digits: 2), emprestados: Faker::Number.number(digits: 2) }
  end
end
