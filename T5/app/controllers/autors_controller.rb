class AutorsController < ApplicationController
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  def index
    @autors = Autor.all
  end

  def show
    @autor = Autor.find(params[:id])
    @livros = @autor.livros
  end

  def new
    @autor = Autor.new
  end

  def create
    @autor = Autor.new(autor_params)
    
    if @autor.save
      redirect_to @autor
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @autor = Autor.find(params[:id])
  end

  def update
    @autor = Autor.find(params[:id])

    if @autor.update(autor_params)
      redirect_to @autor
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @autor = Autor.find(params[:id])
    @autor.destroy

    redirect_to autors_path, status: :see_other
  end

  def autocomplete
    @autores = Autor.where('nome LIKE ?', "%#{params[:term]}%")
    render json: @autores.pluck(:nome)
  end

  private

  def autor_params
    params.require(:autor).permit(:nome, :nacionalidade)
  end
end
