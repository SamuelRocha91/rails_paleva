class BeveragesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_beverage, only: [
    :edit, 
    :show, 
    :update, 
    :destroy,
    :create_offer,
    :deactivate, 
    :activate,
    :offer,
    :edit_offer,
    :update_offer
  ]
  before_action :check_user, only: [:show, :edit, :index, :update]
  before_action :set_format, only: [:create_offer]
  before_action :set_offer, only: [:edit_offer, :update_offer]

  def index
    @beverages = current_user.establishment.beverages
  end

  def new
    @beverage = Beverage.new
  end

  def create
    @beverage = Beverage.new(beverage_params)
    @beverage.establishment = Establishment.find(params[:establishment_id])
    if @beverage.save
      redirect_to establishment_beverages_path, 
                    notice: 'Bebida cadastrada com sucesso'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @beverage.update(beverage_params)
      redirect_to establishment_beverage_path(current_user.establishment, @beverage), 
                    notice: 'Bebida atualizada com sucesso'
    end
  end

  def deactivate
    @beverage.update(status: false)
    redirect_to establishment_beverage_path(
      @beverage.establishment, 
      @beverage
    )
  end

  def activate
    @beverage.update(status: true)
    redirect_to establishment_beverage_path(
      @beverage.establishment, 
      @beverage
    )
  end
  def destroy
    if @beverage.destroy
      redirect_to establishment_beverages_path(current_user.establishment), 
                    notice: 'Registro excluído com sucesso'
    end
  end

  def offer
    @format = Format.new
  end

  def create_offer
    if @beverage.volumes.any? {|volume| volume.active && (volume.format.name == @format.name)}
      flash[:alert] = 'Não é possível cadastrar volumes idênticos para a mesma bebida'
      render :offer, status: :unprocessable_entity
    else
      set_volume 'Volume cadastrado com sucesso'
    end
  end

  def edit_offer; end

  def update_offer
    if @offer.update(active: false)
      @format = Format.find_by(name: params[:format][:name])
      set_volume 'Volume atualizado com sucesso'
    end
  end

  private

  def beverage_params
    params.require(:beverage).permit(
      :name, 
      :description, 
      :calories, 
      :is_alcoholic, 
      :image
    )
  end

  def set_beverage
    @beverage = Beverage.find(params[:id])
  end

  def check_user
    @establishment = Establishment.find(params[:establishment_id])
    if @establishment.user != current_user
      redirect_to root_path, 
        notice: 'Você não possui acesso a essa bebida'
    end
  end

  def set_volume(message)
    volume = @beverage.volumes.new(
      format: @format, 
      details: params[:offer][:details], 
      price: params[:offer][:price].to_f.round(2), 
    )
    if volume.save
      redirect_to establishment_beverage_path(@beverage.establishment, @beverage), 
                    notice: message
    else
      volume.errors.full_messages.each do |error_message|
        @beverage.errors.add(:base, error_message)
      end
      render :offer, status: :unprocessable_entity
    end
  end

  def set_offer
    @offer = Offer.find(params[:offer_id])
  end
end