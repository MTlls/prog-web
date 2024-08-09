require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  setup do
    @pessoa = Pessoa.where(privilegio: 0).first
  end

  test "should create session with valid credentials" do
    # Test both user and admin login
    login_user(@pessoa)
    assert_redirected_to root_path
    assert_equal @pessoa.id, current_pessoa.id # Ensure the session key is correct
  end

  test "should not create session with invalid credentials" do
    post login_path, params: {  }
    assert_nil session[:pessoa_id] # Ensure the session key is correct
    assert_redirected_to root_path
  end
  test "should destroy session" do
    delete logout_path
    assert_redirected_to root_path
    assert_nil session[:pessoa_id] # Garantir que o id da pessoa não está na sessão
  end
end
