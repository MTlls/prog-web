require "test_helper"
require "faker"
Faker::Config.locale = 'pt-BR'

class PessoasControllerTest < ActionDispatch::IntegrationTest
  include SessionsHelper
  
  setup do
    @pessoa = pessoas(:one)  # Certifique-se de ter um fixture chamado `:one` ou ajuste conforme necessário
    @admin = pessoas(:admin)
  end

  test "should get index as admin" do
    login_admin(@admin)
    get pessoas_url
    assert_response :success
  end

  test "should not get index when not admin" do
    login_user(@pessoa)
    get pessoas_url
    assert_response :unauthorized
  end

  test "should show pessoa as admin" do
    login_admin(@admin)
    get pessoa_url(@pessoa)
    assert_redirected_to carteirinha_url(@pessoa.carteirinha)
  end

  test "should show herself" do
    login_user(@pessoa)
    get pessoa_url(@pessoa)
    #  redireciona para a pagina de carteirinha
    assert_redirected_to carteirinha_url(@pessoa.carteirinha)
  end

  test "should not show other pessoa when not admin" do
    login_user(@pessoa)
    get pessoa_url(pessoas(:two))
    assert_response :unauthorized
  end

  test "should get new as admin" do
    login_admin(@admin)
    get new_pessoa_url
    assert_response :success
  end

  test "should not get new when not admin" do
    login_user(@pessoa)
    get new_pessoa_url
    assert_response :unauthorized
  end

  test "should create pessoa as admin" do
    login_admin(@admin)
    assert_difference('Pessoa.count') do
      post pessoas_url, params: { pessoa: generate_pessoa }
    end
    assert_redirected_to pessoa_url(Pessoa.last)
  end
  
  test "should not create pessoa when not admin" do
    login_admin(@pessoa)
    assert_no_difference('Pessoa.count') do
      post pessoas_url, params: { pessoa: generate_pessoa }
    end
    assert_response :unauthorized
  end

  test "should get edit as admin" do
    login_admin(@admin)
    get edit_pessoa_url(@pessoa)
    assert_response :success
  end

  test "should not get edit when not admin" do
    login_user(@pessoa)
    get edit_pessoa_url(@pessoa)
    assert_response :unauthorized
  end

  test "should update pessoa as admin" do
    login_admin(@admin)
    patch pessoa_url(@pessoa), params: { pessoa: update_pessoa }
    assert_redirected_to pessoa_url(@pessoa)
  end

  test "should not update pessoa when not admin" do
    login_user(@pessoa)
    patch pessoa_url(@pessoa), params: { pessoa: update_pessoa }
    assert_response :unauthorized
  end

  test "should destroy pessoa as admin" do
    login_admin(@admin)
    assert_difference('Pessoa.count', -1) do
      delete pessoa_url(@pessoa)
    end
    assert_redirected_to pessoas_url
    # Verifica se a pessoa foi realmente deletada
    assert_nil Pessoa.find_by(id: @pessoa.id)
  end

  test "should not destroy pessoa when not admin" do
    login_user(@pessoa)
    assert_no_difference('Pessoa.count') do
      delete pessoa_url(@pessoa)
    end
    assert_response :unauthorized
  end

  def generate_pessoa
    { nome: Faker::Name.name, email: Faker::Internet.email, cpf: Faker::IdNumber.brazilian_citizen_number, telefone: Faker::PhoneNumber.cell_phone, endereco: Faker::Address.full_address, privilegio: 'comum', password: 'password' }
  end
  def update_pessoa
    #gera mas com um id conhecido
    { nome: Faker::Name.name, email: Faker::Internet.email, cpf: Faker::IdNumber.brazilian_citizen_number, telefone: Faker::PhoneNumber.cell_phone, endereco: Faker::Address.full_address, privilegio: 'comum', password: 'password', IdNumber: Pessoa.all.sample.id }
  end
end
