$:.push './'
require 'active_record'
require 'getoptlong'
require 'livro.rb'
require 'carteirinha.rb'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
:database => "Biblioteca.sqlite3"

class CarteirinhasLivros < ActiveRecord::Base;
    # CRUD
    def self.emprestar(carteirinha, livro)
        carteirinha.livros << livro
        Livro.emprestar(livro)
    end

    def self.devolver(carteirinha, livro)
        carteirinha.livros.delete(livro)
        Livro.devolver(livro)
    end



    def self.listar(chave = nil, valor = nil)
        if chave.nil? && valor.nil?
            # cabeçalho
            puts sprintf(" %-8s | %-35s | %-14s | %-35s","ID Livro","Título","ID Carteirinha","Emprestado por")

            # imprime todos os livros que estao emprestados
            self.all.each do |carteirinha_livro|
                livro = Livro.find_by({:id => carteirinha_livro.livro_id})
                carteirinha = Carteirinha.find_by({:id => carteirinha_livro.carteirinha_id})
                puts sprintf(" %-8s | %-35s | %-14s | %-35s", "#{carteirinha.id}", "#{livro.titulo}", "#{carteirinha.id}", "#{carteirinha.pessoa.nome}")
            end
            return
        end
        # verifica se o campo é carteirinha_id ou livro_id
        if chave == "livro_id"

            livro = Livro.find_by({:id => valor})

            # imprime com quais pessoas os livros estao emprestados
            puts "Pessoas que possuem o livro: #{livro.titulo}\n\n"

            # cabeçalho
            puts sprintf(" %-3s | %-35s ", "ID", "Nome")
            puts "-" * 40
            Livro.find_by({:id => valor}).carteirinhas.each do |carteirinha|
                puts sprintf(" %-3s | %-35s ", "#{carteirinha.id}", "#{carteirinha.pessoa.nome}")
            end
        elsif chave == "carteirinha_id"            
            carteirinha = Carteirinha.find_by({:id => valor})

            puts "Livros emprestados pelo: #{carteirinha.pessoa.nome}\n\n"
            # cabeçalho
            puts sprintf(" %-3s | %-35s | %-20s", "ID", "Título","Autor")
            puts "-" * 60
            # imprime os livros
            Carteirinha.find_by({:id => valor}).livros.each do |livro|
                puts sprintf(" %-3s | %-35s | %-20s", "#{livro.id}", "#{livro.titulo}", "#{livro.autor.nome}")
            end
        end
    end


end

# funcao que captura os campos passados
def get_args(tipo, all_args)
    # Variável para armazenar os argumentos
    args = {}

    if tipo == "lista"
        # Verifica se há um argumento relacionado à carteirinha ou ao livro
        all_args.each do |arg|
            if arg.include?("carteirinha_id")
                args[:carteirinha_id] = arg["carteirinha_id=".length..-1]
                return ["carteirinha_id", args[:carteirinha_id]]
            elsif arg.include?("livro_id")
                args[:livro_id] = arg["livro_id=".length..-1]
                return ["livro_id", args[:livro_id]]
            end
        end
    elsif tipo == "insere" || tipo == "exclui"
        all_args.each do |arg|
            if arg.start_with?("carteirinha_id=")
                args[:carteirinha_id] = arg["carteirinha_id=".length..-1]
            elsif arg.start_with?("livro_id=")
                args[:livro_id] = arg["livro_id=".length..-1]
            end
        end
        return args
    end

    # Retorna nil caso nenhum dos critérios seja atendido
    return nil

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
            # pega os argumentos
            campos = get_args("insere", [arg] + ARGV)

            # verifica se algum dos campos é nulo
            if campos[:carteirinha_id].nil? || campos[:livro_id].nil?
                puts "carteirinha ou livro não encontrado"
            else 
                # faz o emprestimo
                carteirinha = Carteirinha.find_by({:id => campos[:carteirinha_id]})
                livro = Livro.find_by({:id => campos[:livro_id]})
                
                # verifica se o livro ou a carteirinha existe
                if carteirinha.nil? || livro.nil?
                    puts "carteirinha ou livro não encontrado"
                    return
                end

                # verifica se o livro ja nao foi emprestado
                if livro.carteirinhas.include?(carteirinha)
                    puts "Livro já emprestado"
                    return
                end

                CarteirinhasLivros.emprestar(carteirinha, livro)
                puts "Livro emprestado com sucesso!"
            end
        when '--lista'
            # pega os argumentos
            chave, valor = get_args("lista", ARGV)

            if chave.nil? && valor.nil?
                CarteirinhasLivros.listar()
            else 
                # verifica se a carteirinha ou o livro existem
                if Carteirinha.find_by({:id => valor}).nil? && Livro.find_by({:id => valor}).nil?
                    puts "carteirinha ou livro não encontrado"
                    return
                end
                
                CarteirinhasLivros.listar(chave, valor)
            end
        when '--atualiza'
            # nao existe atualiza
            puts "Essa opção não existe"
            exit
        when '--exclui'
            seletor = nil
            valor = nil

            # pega os campos
            campos = get_args("exclui", [arg] + ARGV)

            # faz a devolucao do livro
            carteirinha = Carteirinha.find_by({:id => campos[:carteirinha_id]})
            livro = Livro.find_by({:id => campos[:livro_id]})

            # verifica se há uma relacao entre carteirinha e livro
            carteirinha_livro = CarteirinhasLivros.find_by({:carteirinha_id => carteirinha.id, :livro_id => livro.id})
    
            if carteirinha_livro.nil?
                puts "carteirinha ou livro não emprestou/foi emprestado"
            else
                CarteirinhasLivros.devolver(carteirinha, livro)
                puts "Pessoa excluída com sucesso!"
            end
        end     
    end
end
