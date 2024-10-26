class EstablishmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :establishment_created, only: [:new]
  before_action :set_establishment, only: [:edit, :update]
  def new
    @establishment = Establishment.new
    [:sunday, :monday, :tuesday, :wednesday, 
      :thursday, :friday, :saturday].each do |day|
      @establishment.operating_hours.build(week_day: day)
    end
  end

  def create
    @establishment = Establishment.new(establishment_params)
    @establishment.user = current_user
    if @establishment.save
      redirect_to root_path, notice: 'Cadastro de restaurante efetuado com sucesso!'
    else
      render :new
    end
  end

  def edit;  end

  def update
    if @establishment.update(establishment_params)
      redirect_to root_path, notice: 'Estabelecimento atualizado com sucesso'
    else
      flash.now[:alert] = 'Não foi possível atualizar o estabelecimento'
      render :new
    end
  end

  private

  def establishment_params
    params.require(:establishment).permit(:trade_name, :legal_name, :cnpj, :address,:phone_number, 
                                          :email, operating_hours_attributes:
                                          [:week_day, :start_time, :end_time, :is_closed])
  end

  def establishment_created
    redirect_to root_path if current_user.establishment != nil
  end

  def set_establishment
    @establishment = Establishment.find(params[:id])
  end

end