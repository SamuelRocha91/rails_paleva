class BeveragesController < ApplicationController
  before_action :authenticate_user!

  def index
    @beverages = current_user.establishment.beverages
  end

  def new
    @beverage = Beverage.new
  end

  def create
    @beverage = Beverage.new beverage_params
    @beverage.establishment = current_user.establishment
    if @beverage.save
      redirect_to establishment_beverages_path, notice: 'Bebida cadastrada com sucesso'
    else
      render :new
    end
  end

  def show
  end

  private

  def beverage_params
    params.require(:beverage).permit(:name, :description, :calories, :is_alcoholic, :image)
  end
end