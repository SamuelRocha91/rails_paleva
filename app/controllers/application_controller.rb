class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name cpf])
  end

  def after_sign_in_path_for(resource)
    if current_user.establishment.nil?
      new_establishment_path
    else
      stored_location_for(resource) || root_path
    end
  end

  def check_user_establishment
    return unless user_signed_in? && current_user.establishment.nil?

    redirect_to new_establishment_path,
                alert: 'Você precisa criar um estabelecimento antes de continuar.'
  end

  def employee?
    return unless current_user.employee?

    redirect_to root_path, alert: 'Você não tem permissão para acessar esse recurso.'
  end

  def set_format
    @format = Format.find_by(name: params[:format][:name])
    return unless @format.nil?

    @format = Format.new(name: params[:format][:name])
    if @format.save
      @format
    else
      render :offer, status: :unprocessable_entity
    end
  end
end
