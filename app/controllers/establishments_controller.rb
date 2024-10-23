class EstablishmentsController < ApplicationController
  before_action :authenticate_user!
  def new
    @establishment = Establishment.new
    @establishment.operating_hours.build
  end

  def create
    @establishment = Establishment.new(establishment_params)
    @establishment.user = current_user
    if @establishment.save
      redirect_to @establishment, notice: 'Estabelecimento criado com sucesso.'
    else
      render :new
    end
  end

  private

  def establishment_params
    params.require(:establishment).permit(:trade_name, :legal_name, :cnpj, :address, :phone_number, :email, operating_hours_attributes: [:start_time, :end_time, :is_closed?])
  end
end