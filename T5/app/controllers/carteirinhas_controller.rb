class CarteirinhasController < ApplicationController
  before_action :require_admin, only: [:index, :destroy]

  def index
    @carteirinhas = Carteirinha.all
  end


  def show
    # apenas mostra a carteirinha se for o admin ou a pessoa logada
    if current_pessoa.admin? || current_pessoa == Carteirinha.find(params[:id]).pessoa
      @carteirinha = Carteirinha.find(params[:id])
      @carteirinhas_livros = CarteirinhasLivro.where(carteirinha_id: @carteirinha.id)
    else
      require_admin
    end
  end


  def destroy
    @carteirinha = Carteirinha.find(params[:id])
    @carteirinha.destroy

    redirect_to carteirinhas_path, status: :see_other
  end

  def livros
    @carteirinha = Carteirinha.find(params[:id])
    @carteirinhas_livros = Emprestimo.where(carteirinha_id: @carteirinha.id).includes(:livro)
  end
  
  def list
    if params[:livro_id].present?
      @livro = Livro.find(params[:livro_id])
      @carteirinhas = Carteirinha.all
      @carteirinhas_livro = CarteirinhasLivro.new(livro: @livro)
    end
    render :list
  end

  private
  def carteirinha_params
    params.require(:carteirinha).permit(:podeEmprestar)
  end
end
