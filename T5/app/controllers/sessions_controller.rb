class SessionsController < ApplicationController
  def create
    @pessoa = Pessoa.find_by(email: params[:email])
    if !!@pessoa && @pessoa.authenticate(params[:password])
      session[:pessoa_id] = @pessoa.id
      redirect_to root_path, notice: 'Logged in successfully!'
    else
      flash[:alert] = 'Email ou password inválidos'
      redirect_to root_path
    end
  end
  
  def index
    @pessoas = Pessoa.all
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  def new
    @pessoa = Pessoa.new 
  end

  private

  def sessions_params
    params.permit(:email, :password)
  end
end
