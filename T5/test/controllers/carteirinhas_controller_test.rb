require "test_helper"
require "faker"
Faker::Config.locale = 'pt-BR'

class CarteirinhasControllerTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  setup do
    @carteirinha = carteirinhas(:one) 
    @admin = pessoas(:admin)
  end

  test "should get index as admin" do
    login_admin(@admin)
    get carteirinhas_url
    assert_response :success
  end

  test "should not get index as user" do
    login_user(@carteirinha.pessoa)
    get carteirinhas_url
    assert_response :unauthorized
  end

  test "should show carteirinha as admin" do
    login_admin(@admin)
    get carteirinha_url(@carteirinha)
    assert_response :success
  end

  test "should show herself carteirinha" do
    login_user(@carteirinha.pessoa)
    get carteirinha_url(@carteirinha)
    assert_response :success
  end

  test "should not show carteirinha as other user" do
    login_user(pessoas(:two))
    get carteirinha_url(@carteirinha)
    assert_response :unauthorized
  end

  test "should destroy carteirinha as admin" do
    login_admin(@admin)
    assert_difference('Carteirinha.count', -1) do
      delete carteirinha_url(@carteirinha)
    end
    assert_redirected_to carteirinhas_url
  end

  test "should not destroy carteirinha as user" do
    login_user(@carteirinha.pessoa)
    assert_no_difference('Carteirinha.count') do
      delete carteirinha_url(@carteirinha)
    end
    assert_response :unauthorized
  end

end
