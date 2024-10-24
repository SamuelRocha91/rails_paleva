class EstablishmentsController < ApplicationController
  before_action :authenticate_user!
  def new
    @establishment = Establishment.new
    [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].each do |day|
      @establishment.operating_hours.build(week_day: day)
    end
  end

  def create
    @establishment = Establishment.new(establishment_params)
    @establishment.user = current_user
    if @establishment.save
      redirect_to root_path, notice: 'Estabelecimento criado com sucesso.'
    else
      render :new
    end
  end

  private

  def establishment_params
    params.require(:establishment).permit(:trade_name, :legal_name, :cnpj, :address,:phone_number, 
                                          :email, operating_hours_attributes:
                                          [:week_day, :start_time, :end_time, :is_closed])
  end
end