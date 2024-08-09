require "test_helper"
require "faker"
Faker::Config.locale = 'pt-BR'

class AutorsControllerTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  setup do
    @autor = autors(:one)
    @admin = pessoas(:admin) # Assumindo que você tem um usuário admin nos fixtures
    @non_admin = Pessoa.all.excluding(@admin).sample # Um usuário não admin
  end

  test "should get index" do
    get autors_url
    assert_response :success
  end

  test "should show autor" do
    get autor_url(@autor)
    assert_response :success
  end

  test "should get new as admin" do
    login_admin(@admin) # Método auxiliar para simular login como admin
    get new_autor_url
    assert_response :success
  end

  test "handle new when not admin" do
    login_user(@non_admin) # Método auxiliar para simular login como não admin
    get new_autor_url
    assert_response :unauthorized
  end

  # Adicione testes semelhantes para create, edit, update e destroy
  test "should create autor as admin" do
    login_admin(@admin)
    assert_difference("Autor.count") do
      post autors_url, params:  { autor:  { nome: Faker::Book.author , nacionalidade: Faker::Nation.nationality} }
    end

    assert_redirected_to autor_url(Autor.last)
  end

  test "handle create autor when not admin" do
    login_user(@non_admin)
    assert_no_difference("Autor.count") do
      post autors_url, params: { autor:  { nome: Faker::Book.author , nacionalidade: Faker::Nation.nationality} }
    end

    assert_response :unauthorized
  end

  test "should get edit as admin" do
    login_admin(@admin)
    get edit_autor_url(@autor)
    assert_response :success
  end

  test "handle edit when not admin" do
    login_user(@non_admin)
    get edit_autor_url(@autor)
    assert_response :unauthorized
  end

  test "should update autor as admin" do
    login_admin(@admin)
    nome_novo = Faker::Book.author 
    patch autor_url(@autor), params: { autor:  { nome: nome_novo , nacionalidade: Faker::Nation.nationality} }
    assert_redirected_to autor_url(@autor)
    @autor.reload
    assert_equal nome_novo, @autor.nome
  end

  test "handle update autor when not admin" do
    login_user(@non_admin)
    nome_novo = Faker::Book.author 
    patch autor_url(@autor), params: { autor:  { nome: nome_novo , nacionalidade: Faker::Nation.nationality} }
    assert_response :unauthorized
    @autor.reload
    refute_equal nome_novo, @autor.nome
  end

  test "should destroy autor as admin" do
    login_admin(@admin)
    assert_difference("Autor.count", -1) do
      delete autor_url(@autor)
    end

    assert_redirected_to autors_url
  end

  test "handle destroy autor when not admin" do
    login_user(@non_admin)
    assert_no_difference("Autor.count") do
      delete autor_url(@autor)
    end

    assert_response :unauthorized
  end
end
