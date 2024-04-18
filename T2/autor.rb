$:.push './'
require 'active_record'
require 'getoptlong'
require 'livro.rb'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
:database => "Biblioteca.sqlite3"

class Autor < ActiveRecord::Base;
    has_many :livros, dependent: :destroy
    validate :campo_nao_nulo, :existe_nome

    def campo_nao_nulo
        if nome.nil? || nome.empty?
            errors.add("Nome não pode ser nulo")
        end
        if nacionalidade.nil? || nacionalidade.empty?
            errors.add("Nacionalidade não pode ser nulo")
        end
    end

    def existe_nome
        if Autor.where({nome: nome}).count > 1
            errors.add("Nome já existe")
        end
    end

    # CRUD
    def self.criar(campos)
        autor = Autor.new(campos)
        if autor.invalid?
            autor.errors.each do |message|
                puts "ERRO: #{message}"
            end
            return nil
        end

        autor.save
        return autor
    end

    def self.listar
        autores = Autor.all

        # cabeçalho
        puts sprintf(" %-15s | %-25s | %-15s |","ID","Nome","Nacionalidade")

        autores.each do |autor|
            self.imprime(autor)
        end
    end

    def self.buscar(id)
        autor.find(id)
    end

    def self.imprime(autor)
        puts sprintf(" %-15s | %-25s | %-15s |", autor.id, autor.nome, autor.nacionalidade)
    end

    def self.atualizar(chave, valor, campos)
        autor = self.where({chave => valor})
        
        # verifica se os objetos foram encontrados
        if autor.empty?
            puts "Não foi encontrado o autor com o id informado."
            exit
            return
        end
        
        # atualiza para cada autor
        autor.each do |autor|
            # esse loop verifica se o campo nao eh vazio, se nao for, atualiza
            campos.each do |campo, valor_campo|
                if !valor_campo.nil? && !valor_campo.empty?
                    autor.update({campo => valor_campo})
                end
            end
        end
    end

    def self.deletar(id)
        Autor.destroy(id)
    end
end

# funcao que captura os campos passados
def get_args(all_args)
    args = { nome: nil, nacionalidade: nil}

    all_args.each do |arg|
        if arg.start_with?("nome=")
            args[:nome] = arg["nome=".length..-1]
        elsif arg.start_with?("nacionalidade=")
            args[:nacionalidade] = arg["nacionalidade=".length..-1]
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
            autor = Autor.criar(campos)
            if !autor.nil?
                puts "#{autor.nome} incluído(a) com sucesso!"
            end
        when '--lista'
            Autor.listar()

        when '--atualiza'
            seletor = nil
            valor = nil

            # pega os campos
            campos = get_args(ARGV)
            # split arg em dois para procura futura do objeto
            seletor, valor = arg.split("=");

            # busca o objeto pela condicao
            Autor.atualizar(seletor, valor, campos)
            puts "Campos alterados com sucesso!"

        when '--exclui'
            seletor = nil
            valor = nil

            # pega os campos
            campos = get_args(ARGV)
            # split arg em dois para procura futura do objeto
            seletor, valor = arg.split("=");

            # busca o autor pela condicao e verifica a existencia
            autores = Autor.where({seletor => valor})
            if autores.empty?
                puts "Não foi encontrado(s) o(s) autores."
                exit
            end
            autores.each do |autor|
                Autor.deletar(autor.id)
                puts "Autor excluído(a) com sucesso!"
            end
        end     
    end
end
