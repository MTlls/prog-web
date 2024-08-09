class PessoasController < ApplicationController
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy, :index]

  def index
    @pessoas = Pessoa.all
  end

  def show
    # apenas mostra a pessoa se for o admin ou a pessoa logada
    if current_pessoa.admin? || current_pessoa.id == params[:id].to_i
      # redireciona para a carteirinha
      redirect_to carteirinha_path(Pessoa.find(params[:id]).carteirinha)
    else
      require_admin
    end
  end

  def new
    @pessoa = Pessoa.new
  end

  def create
    @pessoa = Pessoa.new(pessoa_params)
    @pessoa.carteirinha = Carteirinha.new(podeEmprestar: true)
    # Verifica se já existe uma pessoa com o mesmo e-mail
    if @pessoa.save
      @pessoa.carteirinha.save
      if !logged_in?
        session[:pessoa_id] = @pessoa.id
      end
      redirect_to @pessoa
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @pessoa = Pessoa.find(params[:id])
  end

  def update
    @pessoa = Pessoa.find(params[:id])
    logger.debug "pessoa_params"
    logger.debug @pessoa
    if @pessoa.update(pessoa_params)
      redirect_to @pessoa
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pessoa = Pessoa.find(params[:id])
    @pessoa.destroy

    redirect_to pessoas_path, status: :see_other
  end

  private

  def pessoa_params
    params.require(:pessoa).permit(:nome, :email, :cpf, :telefone, :endereco, :privilegio, :password, :password_confirmation)
  end
end
