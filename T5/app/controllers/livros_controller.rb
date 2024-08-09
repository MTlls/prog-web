class LivrosController < ApplicationController
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  def index
    @livros = Livro.all
  end

  def show
    @livro = Livro.find(params[:id])
  end

  def new
    @livro = Livro.new
    @autors = Autor.all
  end

  def create
    @autor = Autor.find_by(id: params[:livro][:autor_id])
    @livro = Livro.new(livro_params.merge(autor: @autor))

    # se o autor nao existir, mostra uma mensagem de erro
    if @autor.nil?
      @livro.errors.add(:autor_nome, "não encontrado")
      return render :new, status: :unprocessable_entity
    end
    if @livro.save
      redirect_to @livro
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @livro = Livro.find(params[:id])
    @autor = @livro.autor
  end

  def update
    @livro = Livro.find(params[:id])
    @autor = Autor.find_by(id: params[:livro][:autor_id])
    # se o autor nao existir, mostra uma mensagem de erro
    if @autor.nil?
      @livro.errors.add(:autor_nome, "não encontrado")
      return render :edit, status: :unprocessable_entity
    end
    if @livro.update(livro_params.merge(autor: @autor))
      redirect_to @livro
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def autocomplete  
    logger.debug params.inspect
    @livros = Livro.where('titulo LIKE ?', "%#{params[:term]}%").limit(10)
    render json: @livros.map(&:titulo).uniq 
  end
  
  def destroy
    @livro = Livro.find(params[:id])
    @livro.destroy

    redirect_to livros_path, status: :see_other
  end

  def list
    if params[:carteirinha_id].present?
      @carteirinha = Carteirinha.find(params[:carteirinha_id])
      @livros = @carteirinha.livros
    # se o parametro recebido for o autor id, busca os livros do autor
    elsif params[:autor_id].present?
      @autor = Autor.find(params[:autor_id])
      @livros = @autor.livros
    end
    render :list
  end

  private

  def livro_params
    params.require(:livro).permit(:titulo, :ano, :genero, :quantidade, :emprestados, :autor_id)
  end
end
