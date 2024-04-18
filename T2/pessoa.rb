$:.push './'
require 'getoptlong'
require 'active_record'
require 'carteirinha.rb'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
:database => "Biblioteca.sqlite3"

class Pessoa < ActiveRecord::Base;
    has_one :carteirinha, dependent: :destroy
    validate :campo_nao_nulo
 
    def campo_nao_nulo
        if nome.nil? || nome.empty?
            errors.add("Nome não pode ser nulo")
        end
        if cpf.nil?
            errors.add("CPF não pode ser nulo")
        end
        if email.nil? || email.empty?
            errors.add("Email não pode ser nulo")
        end
        if telefone.nil? || telefone.empty?
            errors.add("Telefone não pode ser nulo")
        end
        if endereco.nil? || endereco.empty?
            errors.add("Endereço não pode ser nulo")
        end
    end

    def self.criar(campos)
        pessoa = self.new(campos)
        if pessoa.invalid?
            pessoa.errors.each do |message|
                puts "ERRO: #{message}"
            end
            return
        end
        
        pessoa.save
        return pessoa
    end
    def self.listar
        pessoas = self.all

        # imprime o cabecalho
        puts sprintf("%-20s | %-12s | %-25s | %-12s | %-25s | %s\n", "Nome", "CPF", "Email", "Telefone", "Endereço", "ID carteira");

        pessoas.each do |pessoa|
            # procura a carteira da pessoa
            carteira = pessoa.carteirinha

            # imprime os dados da pessoa            
            puts sprintf("%-20s | %-12s | %-25s | %-12s | %-25s | %s\n",
            pessoa.nome, pessoa.cpf, pessoa.email, pessoa.telefone, pessoa.endereco, pessoa.carteirinha ? carteira.id : "0")
       end
    end

    def self.buscar(id)
        return self.find(id)
    end

    def self.atualizar(chave, valor, campos)
        pessoas = self.where({chave => valor})
        
        # verifica se os objetos foram encontrados
        if pessoas.empty?
            puts "Nenhuma pessoa encontrada com os critérios especificados."
            exit
            return
        end
        
        # atualiza para cada pessoa
        pessoas.each do |pessoa|
            # esse loop verifica se o campo nao eh vazio, se nao for, atualiza
            campos.each do |campo, valor_campo|
                if !valor_campo.nil? && !valor_campo.empty?
                    pessoa.update({campo => valor_campo})
                end
            end
        end
    end

    def self.deletar(id)
        self.destroy(id)
    end
end


# funcao que captura os campos passados
def get_args(all_args)
    args = { nome: nil, endereco: nil, cpf: nil, email: nil, telefone: nil }

    all_args.each do |arg|
        if arg.start_with?("endereco=")
            args[:endereco] = arg["endereco=".length..-1]
        elsif arg.start_with?("cpf=")
            args[:cpf] = arg["cpf=".length..-1]
        elsif arg.start_with?("email=")
            args[:email] = arg["email=".length..-1]
        elsif arg.start_with?("telefone=")
            args[:telefone] = arg["telefone=".length..-1]
        elsif arg.start_with?("nome=")
            args[:nome] = arg["nome=".length..-1]
        end
    end

    return args
end

opts = GetoptLong.new(
  [ '--insere', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--atualiza', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--exclui',  GetoptLong::REQUIRED_ARGUMENT ],
  [ '--lista', GetoptLong::NO_ARGUMENT ]
)

nome = nil
endereco = nil
cpf = nil
email = nil
telefone = nil

# Verifica se o arquivo foi chamado com argumentos
if __FILE__ == $0
    # Processa as opções
    opts.each do |opt, arg|
        case opt
        when '--insere'
            # contatena arg1 + all_args
            # retorna todos os campos em uma variavel
            campos = get_args([arg] + ARGV)

            # Cria e salva a pessoa com os campos
            pessoa = Pessoa.criar(campos)
            if !pessoa.nil?
                puts "Pessoa #{pessoa.nome} incluída com sucesso!"
            else 
                puts "Erro ao incluir pessoa."
            end

        when '--lista'
            Pessoa.listar()

        when '--atualiza'
            seletor = nil
            valor = nil

            # pega os campos
            campos = get_args(ARGV)
            # split arg em dois para procura futura do objeto
            seletor, valor = arg.split("=");

            # busca o objeto pela condicao
            Pessoa.atualizar(seletor, valor, campos)
            puts "Campos alterados com sucesso!"

        when '--exclui'
            seletor = nil
            valor = nil

            # pega os campos
            campos = get_args([arg] + ARGV)
            
            # deleta os campos nulos
            campos.delete_if { |key, value| value.nil? || value.empty? }

            # busca as pessoas com os campos especificados, verifica se existe e deleta, eh necessario que os campos nulos nao aparecam na busca
            pessoas = Pessoa.where(campos)

            if pessoas.empty?
                puts "Nenhuma pessoa encontrada com os critérios especificados."
                exit
            else 
                pessoas.each do |pessoa|
                    Pessoa.deletar(pessoa.id)
                    puts "Pessoa excluída com sucesso!"
                end
            end
        end     
    end
end