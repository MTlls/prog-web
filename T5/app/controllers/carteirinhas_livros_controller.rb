# app/controllers/carteirinhas_livros_controller.rb
class CarteirinhasLivrosController < ApplicationController
  before_action :require_admin, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :require_logged_in

  def index
    @carteirinhas_livros = CarteirinhasLivro.all
  end

  def show
    @carteirinhas_livro = CarteirinhasLivro.find(params[:id])
  end

  def new
    @carteirinhas_livro = CarteirinhasLivro.new
    @livros = Livro.all
    @carteirinhas = Carteirinha.all
  end

  def create
    @carteirinhas_livro = CarteirinhasLivro.new(carteirinhas_livro_params)
    # diminui a quantidade de livros disponíveis, se houver
    if @carteirinhas_livro.livro.quantidade - @carteirinhas_livro.livro.emprestados > 0
      @carteirinhas_livro.livro.emprestados += 1
    else
      @carteirinhas_livro.errors.add(:livro_id, "não disponível")
      return render :new, status: :unprocessable_entity
    end

    if @carteirinhas_livro.save
      redirect_to @carteirinhas_livro, notice: "Empréstimo criado com sucesso."
    else
      @livros = Livro.all
      @carteirinhas = Carteirinha.all
      render :new, status: :unprocessable_entity
    end
  end

  def extend
    @carteirinhas_livro = CarteirinhasLivro.find(params[:id])
    if @carteirinhas_livro.update(carteirinhas_livro_params)
      redirect_to @carteirinhas_livro, notice: "Data de devolução estendida com sucesso."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update
    @carteirinhas_livro = CarteirinhasLivro.find(params[:id])

    if @carteirinhas_livro.update(carteirinhas_livro_params)
      redirect_to @carteirinhas_livro, notice: "Empréstimo atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
    @carteirinhas_livro = CarteirinhasLivro.find(params[:id])
    @livros = Livro.all
    @carteirinhas = Carteirinha.all
  end

  def destroy
    @carteirinhas_livro = CarteirinhasLivro.find(params[:id])
    @carteirinhas_livro.destroy
    
    redirect_to carteirinhas_livros_path, status: :see_other
  end

  private

  def set_livros_and_carteirinhas
    @livros = Livro.all
    @carteirinhas = Carteirinha.all
  end

  def carteirinhas_livro_params
    params.require(:carteirinhas_livro).permit(:carteirinhas_livro_id, :livro_id, :carteirinha_id, :data_carteirinhas_livro, :data_devolucao, :data_emprestimo)
  end
end
