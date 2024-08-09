require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  setup do
    # para cada um, pega um elemento aleatorio
    @livro = Livro.all.sample
    @autor = Autor.all.sample
    @pessoa = Pessoa.where(privilegio: 0).sample # uma pessoa comum
    @admin = pessoas(:admin) # um admin
  end

  test "should get search results for livros" do
    get search_url(query: @livro.titulo, search_type: "livros")
    assert_response :success
    assert_select "table tbody tr", minimum: 1
  end

  test "should get search results for autores" do
    get search_url, params: { query: @autor.nome }

    assert_response :success
    assert_select "table tbody tr", minimum: 1
  end

  test "should handle empty search query" do
    get search_url(query: "", search_type: "")
    assert_response :success
    assert_select "table tbody tr", minimum: 1
  end

  test "should get search by admin user" do
    post login_path, params: { email: @admin.email, password: 'admin'}
    # puts "Usuario logado: " + current_pessoa.inspect
    get search_url(query: "", search_type: "pessoas")
    assert_response :success  # Espera-se sucesso para um admin
    # log do que veio como resposta
    # puts @response.body
    assert_select "table tbody tr", minimum: 1  # Verifica se pelo menos um resultado é retornado
  end
  
  test "should handle invalid search type for non-admin user" do
    post login_path, params: {  email: @pessoa.email, password: "password" } 
    sign_in @pessoa  # Simula login como um usuário comum
    get search_url(query: "", search_type: "pessoas")

    assert_response :unauthorized

    assert_includes @response.body, "Acesso não autorizado!" 
  end

end
