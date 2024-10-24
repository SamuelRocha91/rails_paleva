class EstablishmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :establishment_created, only: [:new]
  before_action :start_establishment, only: [:new, :edit]
  def new; end

  def create
    @establishment = Establishment.new(establishment_params)
    @establishment.user = current_user
    if @establishment.save
      redirect_to root_path, notice: 'Cadastro de restaurante efetuado com sucesso!'
    else
      render :new
    end
  end

  def edit; end

  private

  def establishment_params
    params.require(:establishment).permit(:trade_name, :legal_name, :cnpj, :address,:phone_number, 
                                          :email, operating_hours_attributes:
                                          [:week_day, :start_time, :end_time, :is_closed])
  end

  def establishment_created
    redirect_to root_path if current_user.establishment != nil
  end

  def start_establishment
    @establishment = Establishment.new
    [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].each do |day|
      @establishment.operating_hours.build(week_day: day)
    end
  end

end