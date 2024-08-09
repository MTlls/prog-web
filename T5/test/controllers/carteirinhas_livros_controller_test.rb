# test/controllers/carteirinhas_livros_controller_test.rb
require "test_helper"
require "faker"
Faker::Config.locale = 'pt-BR'

class CarteirinhasLivrosControllerTest < ActionDispatch::IntegrationTest
  include SessionsHelper
  setup do
    @carteirinhas_livro = carteirinhas_livros(:one) 
    @non_admin = Pessoa.where(privilegio: 0).first
    @carteirinha = Carteirinha.all.sample
    @admin = Pessoa.where(privilegio: 1).first
  end

  test "should get emprestimo index as admin" do
    login_admin(@admin)
    get carteirinhas_livros_url
    assert_response :success
  end

  test "should not get emprestimo index as user" do
    login_user(@non_admin)
    get carteirinhas_livros_url
    assert_response :unauthorized
  end

  test "should get new emprestimo as admin" do
    login_admin(@admin)
    get new_carteirinhas_livro_url
    assert_response :success
  end

  test "should not get emprestimo new as user" do
    login_user(@non_admin)
    get new_carteirinhas_livro_url
    assert_response :unauthorized
  end

  test "should create emprestimo as admin" do
    login_admin(@admin)
    assert_difference('CarteirinhasLivro.count') do
      post carteirinhas_livros_url, params: { carteirinhas_livro: generate_carteirinhas_livro } 
    end
    assert_redirected_to carteirinhas_livro_url(CarteirinhasLivro.last)
  end
    
  test "should not create emprestimo when not admin" do
    login_user(@non_admin)
    post carteirinhas_livros_url, params: { carteirinhas_livro: generate_carteirinhas_livro }
    assert_response :unauthorized
  end

  test "should show emprestimo as admin" do
    login_admin(@admin)
    get carteirinhas_livro_url(@carteirinhas_livro)
    assert_response :success
  end

  test "should show emprestimo as user" do
    login_user(@non_admin)
    get carteirinhas_livro_url(@carteirinhas_livro)
    assert_response :success
  end

  test "should not show emprestimo when not logged in" do
    get carteirinhas_livro_url(@carteirinhas_livro)
    assert_response :unauthorized
  end

  test "should get edit as admin" do
    login_admin(@admin)
    get edit_carteirinhas_livro_url(@carteirinhas_livro)
    assert_response :success
  end

  test "should not get edit as user" do
    login_user(@non_admin)
    get edit_carteirinhas_livro_url(@carteirinhas_livro)
    assert_response :unauthorized
  end

  test "should update emprestimo as admin" do
    login_admin(@admin)
    patch carteirinhas_livro_url(@carteirinhas_livro), params: { carteirinhas_livro: { devolvido: true } }
    assert_redirected_to carteirinhas_livro_url(@carteirinhas_livro)
  end

  test "should not update emprestimo when not admin" do
    login_user(@non_admin)
    patch carteirinhas_livro_url(@carteirinhas_livro), params: { carteirinhas_livro: { devolvido: true } }
    assert_response :unauthorized
  end

  test "should destroy emprestimo as admin" do
    login_admin(@admin)
    assert_difference('CarteirinhasLivro.count', -1) do
      delete carteirinhas_livro_url(@carteirinhas_livro)
    end
    assert_redirected_to carteirinhas_livros_url
  end

  test "should not destroy emprestimo when not admin" do
    login_user(@non_admin)
    assert_no_difference('CarteirinhasLivro.count') do
      delete carteirinhas_livro_url(@carteirinhas_livro)
    end
    assert_response :unauthorized
  end

  private
  def generate_carteirinhas_livro
    {
      
      livro_id: Livro.first.id,
      carteirinha_id: @carteirinha.id,
      data_emprestimo: Date.today,
      data_devolucao: Date.today + 7.days,
    }
  end

end
