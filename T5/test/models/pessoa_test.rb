# test/models/pessoa_test.rb
require "test_helper"

class PessoaTest < ActiveSupport::TestCase
  test "should be valid with unique attributes" do
    pessoa = Pessoa.new(
      nome: "Marcelo Oliveira",
      cpf: 98765432100,
      email: "mo@example.com",
      telefone: "0987654321",
      endereco: "Avenida Exemplo, 456",
      password: "senha_secreta",
      privilegio: 1,
    )

    # Verifica se o registro é válido com atributos únicos
    assert pessoa.valid?
    assert pessoa.save, "Failed to save valid pessoa"
  end

  # Teste para verificar que o CPF é único
  test "should not be valid with duplicate cpf" do
    existing_pessoa = pessoas(:one) # Supondo que este fixture já existe e tem um CPF
    # cria uma pessoa com o mesmo CPF
    pessoa = Pessoa.new(
      cpf: existing_pessoa.cpf,
      nome: "Ana Souza",
      email: "blablabla@gmail.com",
      telefone: "0987654321",
      endereco: "Avenida Exemplo, 789",
      password: "senha_diferente",
      privilegio: 1,
    )

    refute pessoa.valid?
    assert_includes pessoa.errors[:cpf], "has already been taken"
  end

  # Teste para verificar que o email é único
  test "should not be valid with duplicate email" do
    existing_pessoa = pessoas(:one) # Supondo que este fixture já existe e tem um email
    pessoa = Pessoa.new(
      nome: "Ana Souza",
      cpf: 11223344556,
      email: existing_pessoa.email, # Usando o mesmo email
      telefone: "0987654321",
      endereco: "Avenida Exemplo, 789",
      password: "senha_diferente",
      privilegio: 1,
    )

    refute pessoa.valid?
    assert_includes pessoa.errors[:email], "has already been taken"
  end

  # Teste para verificar a presença do nome
  test "should not be valid without nome" do
    pessoa = Pessoa.new(pessoas(:one).attributes.except("nome"))
    assert_not pessoa.valid?
  end

  # Teste para verificar a presença do email
  test "should not be valid without email" do
    pessoa = Pessoa.new(pessoas(:two).attributes.except("email"))
    assert_not pessoa.valid?
  end

  # Teste para verificar a presença do CPF
  test "should not be valid without cpf" do
    pessoa = Pessoa.new(pessoas(:two).attributes.except("cpf"))
    assert_not pessoa.valid?
  end

  # Teste de associação com carteirinha
  test "should have one carteirinha" do
    pessoa = pessoas(:one) # Supondo que você tenha um fixture
    assert_respond_to pessoa, :carteirinha
  end
end
