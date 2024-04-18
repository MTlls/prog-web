$:.push './'
require 'getoptlong'
require 'active_record'
require 'carteirinha.rb'
require 'autor.rb'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
:database => "Biblioteca.sqlite3"

class Livro < ActiveRecord::Base;
    unless self.method_defined?(:carteirinhas)
        has_and_belongs_to_many :carteirinhas, -> {distinct}
    end
    belongs_to :autor
    validate :campo_nao_nulo

    def campo_nao_nulo
        if titulo.nil? || titulo.empty?
            errors.add("Título não pode ser nulo")
        end
        if ano.nil? || ano.empty?
            errors.add("Ano não pode ser nulo")
        end
        if genero.nil? || genero.empty?
            errors.add("Gênero não pode ser nulo")
        end
        if quantidade.nil?
            errors.add("Quantidade não pode ser nulo")
        end
    end


    # CRUD
    def self.criar(campos)
        autor = Autor.find_by({nome: campos[:autor]})

        if autor.nil?
            puts "Autor não encontrado"
            return nil
        end

        # tira o campo do autor 
        campos.delete(:autor)

        # cria o livro
        livro = Livro.new(campos)

        # associa o autor ao livro
        livro.autor = autor

        if livro.invalid?
            livro.errors.each do |message|
                puts "ERRO: #{message}"
            end
            return nil
        end

        livro.save
        return livro
    end

    def self.listar
        livros = Livro.all

        # cabeçalho
        puts sprintf(" %-3s | %-35s | %-30s | %-4s | %-10s |  %-10s | %-10s ","ID","Título","Autor","Ano","Gênero", "Quantidade", "Emprestados")

        livros.each do |livro|
            Livro.imprime(livro)
        end
    end

    def self.imprime(livro)
        puts sprintf(" %-3s | %-35s | %-30s | %-4s | %-10s |  %-10s | %-10s ", livro.id ,livro.titulo, livro.autor.nome, livro.ano, livro.genero, livro.quantidade, livro.carteirinhas.count)
    end

    def self.buscar(id)
        livro.find(id)
    end

    def self.atualizar(chave, valor, campos)
        livros = self.where({chave => valor})
        
        # verifica se os objetos foram encontrados
        if livros.empty?
            puts "Não foi encontrado o livro com o id informado."
            exit
            return
        end
        
        livros.each do |livro|
            # esse loop verifica se o campo nao eh vazio, se nao for, atualiza
            campos.each do |campo, valor_campo|
                if !valor_campo.nil? && !valor_campo.empty?
                    livro.update({campo => valor_campo})
                end
            end        
        end
    end

    def self.deletar(id)
        livro = self.find(id)
        livro.destroy
    end

    def self.devolver(livro)
        livro.save
    end

    def self.emprestar(livro)
        livro.save
    end

    def self.exists?(campos)
        if campos.has_key?(:id)
            return Livro.exists?(campos[:id])
        end

        return false
    end

    def self.find_by(campos)
        if campos.has_key?(:id)
            return Livro.find(campos[:id])
        end
    end
end


# funcao que captura os campos passados
def get_args(all_args)
    args = { titulo: nil, ano: nil, genero: nil, quantidade: nil, autor: nil}

    all_args.each do |arg|
        if arg.start_with?("titulo=")
            args[:titulo] = arg["titulo=".length..-1]
        elsif arg.start_with?("ano=")
            args[:ano] = arg["ano=".length..-1]
        elsif arg.start_with?("genero=")
            args[:genero] = arg["genero=".length..-1]
        elsif arg.start_with?("quantidade=")
            args[:quantidade] = arg["quantidade=".length..-1]
        elsif arg.start_with?("autor=")
            args[:autor] = arg["autor=".length..-1]
        end
    end
    # puts args
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
            livro = Livro.criar(campos)
            if !livro.nil?
                puts "#{livro.titulo} incluído(a) com sucesso!"
            end

        when '--lista'
            Livro.listar()

        when '--atualiza'
            seletor = nil
            valor = nil

            # pega os campos
            campos = get_args(ARGV)
            # split arg em dois para procura futura do objeto
            seletor, valor = arg.split("=");

            # busca o objeto pela condicao
            Livro.atualizar(seletor, valor, campos)
            puts "Campos alterados com sucesso!"

        when '--exclui'
            seletor = nil
            valor = nil

            # pega os campos
            campos = get_args(ARGV)
            # split arg em dois para procura futura do objeto
            seletor, valor = arg.split("=");

            # busca o livro pela condicao e verifica a existencia
            livros = Livro.where({seletor => valor})
            if livros.empty?
                puts "Não foi encontrado(s) o(s) livros."
                exit
            end
            livros.each do |livro|
                Livro.deletar(livro.id)
                puts "Livro excluído com sucesso!"
            end
        end     
    end
end
