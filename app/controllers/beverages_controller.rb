class BeveragesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_beverage, only: [:edit, :show, :update]
  before_action :check_user, only: [:show, :edit, :index]

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
      redirect_to establishment_beverages_path, notice: 'Bebida cadastrada com sucesso'
    else
      render :new
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

  private

  def beverage_params
    params.require(:beverage).permit(:name, :description, :calories, :is_alcoholic, :image)
  end

  def set_beverage
    @beverage = Beverage.find(params[:id])
  end

  def check_user
    @establishment = Establishment.find(params[:establishment_id])
    if @establishment.user != current_user
      redirect_to root_path, notice: 'Você não possui acesso a essa bebida'
    end
  end
end