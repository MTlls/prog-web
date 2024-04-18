$:.push './'
require 'active_record'
require 'getoptlong'
require 'livro.rb'
require 'pessoa.rb'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
:database => "Biblioteca.sqlite3"

class Carteirinha < ActiveRecord::Base;
    unless self.method_defined?(:livros)
        has_and_belongs_to_many :livros, -> {distinct}
    end
    validate :existe_pessoa, :pessoa_nao_tem_carteirinha
    belongs_to :pessoa


    def existe_pessoa
        if pessoa_id.nil? || !Pessoa.exists?(pessoa_id)
            errors.add(:pessoa, "Não foi encontrada a pessoa com o id informado")
        end
    end
    
    def pessoa_nao_tem_carteirinha
        if !pessoa_id.nil? && Carteirinha.exists?(pessoa_id)
            errors.add(:pessoa, "Há uma carteirinha vinculada a essa pessoa")
        end
    end
    

    def self.criar(seletor, valor)
        # verifica se ha uma pessoa com o id informado
        # se houver mais de uma pessoa com o id informado, o primeiro é escolhido
        pessoa = Pessoa.where({seletor => valor}).first
        carteira = self.new({pessoa: pessoa, podeEmprestar: true})

        # verifica se a carteira é válida
        if carteira.invalid?
            carteira.errors[:pessoa].each do |message|
                puts "ERRO: #{message}"
            end
        else
            carteira.save
            return carteira
        end
        carteira = nil
    end

    def self.listar
        carteiras = self.all

        # cabeçalho
        puts sprintf(" %-3s | %-20s | %-11s | %-15s ","ID","Pessoa","Livros","Disponibilidade")

        carteiras.each do |carteira|
            self.imprime(carteira)
        end
    end

    def self.buscar(id)
       carteirinha.find(id)
    end

    def self.atualizar(chave, valor, campos)
        carteirinha = self.where({chave => valor})
        
        # verifica se os objetos foram encontrados
        if carteirinha.empty?
            puts "Não foi encontrada nenhuma carteirinha com o id informado"
            exit
            return
        end
        
        # atualiza para cada carteirinha
        carteirinha.each do |carteirinha|
            # esse loop verifica se o campo nao eh vazio, se nao for, atualiza
            campos.each do |campo, valor_campo|
                if !valor_campo.nil? && !valor_campo.empty?
                    carteirinha.update({campo => valor_campo})
                end
            end
        end
    end

    def self.deletar(id)
        # devolve todos os livros para a biblioteca
        carteira = self.find(id)
        carteira.livros.each do |livro|
            Livro.devolver(livro)
        end
        
       self.destroy(id)
    end

    def self.adicionarLivro(id, livro)
        carteira = carteirinha.find(id)
        carteira.livros << livro
    end

    def self.removerLivro(id, livro)
        carteira = carteirinha.find(id)
        carteira.livros.delete(livro)
    end

    def self.listarLivros(id)
        carteira = carteirinha.find(id)

        # cabeçalho
        puts sprintf(" %-3s | %-35s | %-30s | %-4s | %-10s |  %-10s | %-10s ","ID","Título","Autor", "Ano","Gênero", "Quantidade", "Emprestados")

        carteira.livros.each do |livro|
            Livros.imprime(livro)
        end
    end

    def self.imprime(carteirinha)
        puts sprintf(" %-3s | %-20s | %-11s | %-15s ", "#{carteirinha.id}" ,"#{carteirinha.pessoa.nome}", "#{carteirinha.livros.count}", "#{carteirinha.podeEmprestar ? "disponível" : "não disponível"}")
    end
        
end

def get_args(args)
    # cria um hash vazio
    campos = {}

    # percorre os argumentos
    args.each do |arg|
        # verifica se o argumento é uma chave
        if arg.include?("--")
            # pega a chave
            chave = arg.gsub("--", "")
            campos[chave.to_sym] = nil
        else
            # pega o valor
            campos[chave.to_sym] = arg
        end
    end

    return campos
end


opts = GetoptLong.new(
  [ '--insere', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--atualiza', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--exclui',  GetoptLong::REQUIRED_ARGUMENT ],
  [ '--lista', GetoptLong::NO_ARGUMENT ]
)

# Verifica se o arquivo foi chamado com argumentos
if __FILE__ == $0
    # Processa as opções
    opts.each do |opt, arg|
        case opt
        when '--insere'
            # retorna todos os campos em uma variavel
            seletor, valor = arg.split("=");

            # Cria e salva a carteirinha com os campos
            carteirinha = Carteirinha.criar(seletor, valor)

            if !carteirinha.nil?
                puts "carteirinha da pessoa #{carteirinha.pessoa.nome} incluída com sucesso!"
            end
        when '--lista'
            Carteirinha.listar()

        when '--atualiza'
            seletor = nil
            valor = nil

            # pega os campos
            campos = get_args(ARGV)
            # split arg em dois para procura futura do objeto
            seletor, valor = arg.split("=");

            # busca o objeto pela condicao
            Carteirinha.atualizar(seletor, valor, campos)
            puts "Campos alterados com sucesso!"

        when '--exclui'
            seletor = nil
            valor = nil

            # pega os campos
            campos = get_args([arg] + ARGV)
            
            # deleta os campos nulos
            campos.delete_if { |key, value| value.nil? || value.empty? }
            
            # busca a carteira pela condicao
            # verifica se existe algum elemento nas tabelas de pessoa e de carteirinha que atendam alguma das condições
            if Pessoa.where?(campos)
                # aqui é feita a destruicao da carteirinha
                elemento = Pessoa.find_by(campos)
            elsif Carteirinha.exists?(campos)
                # aqui é feita a destruicao da carteirinha
                elemento = Carteirinha.find_by(campos)
            elsif
                puts "Não foi encontrada a carteirinha com o id informado"
                exit
            end
            
            Carteirinha.deletar(elemento.id)

            puts "Pessoa excluída com sucesso!"
        end     
    end
end
