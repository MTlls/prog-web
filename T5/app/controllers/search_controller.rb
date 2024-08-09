class SearchController < ApplicationController
  # precisa de admin para pesquisar pessoas
  def index
    @query = params[:query]
    @search_type = params[:search_type]

    @results = {
      autores: [],
      livros: [],
      pessoas: [],
    }

    if @search_type == "pessoas"
      require_admin
    end

    if !@query.blank?
      case @search_type
      when "autores"
        @results[:autores] = Autor.where("nome LIKE ?", "%#{@query}%")
      when "livros"
        @results[:livros] = Livro.where("titulo LIKE ?", "%#{@query}%")
      when "pessoas"
        @results[:pessoas] = Pessoa.where("nome LIKE ?", "%#{@query}%")
      else
        @results[:autores] = Autor.where("nome LIKE ?", "%#{@query}%")
        @results[:livros] = Livro.where("titulo LIKE ?", "%#{@query}%")
        if admin?
          @results[:pessoas] = Pessoa.where("nome LIKE ?", "%#{@query}%")
        end
      end
    else
      # Se a query não estiver presente, retorna todos os registros
      case @search_type
      when "autores"
        @results[:autores] = Autor.all
      when "livros"
        @results[:livros] = Livro.all
      when "pessoas"
        @results[:pessoas] = Pessoa.all
      else
        @results[:autores] = Autor.all
        @results[:livros] = Livro.all
        if admin?
          @results[:pessoas] = Pessoa.all
        end
      end
    end
  end

  def autocomplete
    search_type = params[:search_type]
    query = params[:term]

    results = []
    case search_type
    when "autores"
      results = Autor.where("nome LIKE ?", "%#{query}%").pluck(:nome)
    when "livros"
      results = Livro.where("titulo LIKE ?", "%#{query}%").pluck(:titulo)
    else
      results = Autor.where("nome LIKE ?", "%#{query}%").pluck(:nome) +
                Livro.where("titulo LIKE ?", "%#{query}%").pluck(:titulo) +
                (admin? ? Pessoa.where("nome LIKE ?", "%#{query}%").pluck(:nome) : [])
    end
    render json: results
  end
end
