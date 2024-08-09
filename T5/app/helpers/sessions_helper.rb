module SessionsHelper
  def logged_in?
    Rails.logger.debug "Session ID: #{session[:pessoa_id]}"

    !!session[:pessoa_id]
  end

  def sign_in(pessoa)
    session[:pessoa_id] = pessoa.id
  end

  def current_pessoa
    @current_pessoa ||= Pessoa.find_by(id: session[:pessoa_id]) if session[:pessoa_id].present?
  end

  def sign_out
    session.delete(:pessoa_id)
    @current_pessoa = nil
  end

  def require_admin
    unless admin?
      render json: { error: "Acesso não autorizado!" }, status: :unauthorized
    end
  end

  def require_logged_in
    unless logged_in?
      render json: { error: "Acesso não autorizado!" }, status: :unauthorized
    end
  end
  
  def admin?
    current_pessoa && current_pessoa.admin?
  end
end
