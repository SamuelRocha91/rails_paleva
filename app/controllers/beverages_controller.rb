class BeveragesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_beverage, only: [:edit, :show]

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

  private

  def beverage_params
    params.require(:beverage).permit(:name, :description, :calories, :is_alcoholic, :image)
  end

  def set_beverage
    @beverage = Beverage.find(params[:id])
  end
end