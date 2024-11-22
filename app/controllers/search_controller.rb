class SearchController < ApplicationController
  before_action :employee?, only: [:search]

  def search
    if params[:type] == 'Bebida'
      search_beverages
      @count = @beverages.length
    elsif params[:type] == 'Comida'
      search_dishes
      @count = @dishes.length
    else
      search_beverages
      search_dishes
      @count = @beverages.length + @dishes.length
    end
  end

  def search_order
    @order = Order.find_by(code: params[:query])
  end

  private

  def search_beverages
    @beverages = Beverage.where('name LIKE ? or description LIKE ? ',
                                  "%#{params[:query]}%",  "%#{params[:query]}%")
  end

  def search_dishes
    @dishes = Dish.left_joins(:tags).where('Dishes.name LIKE ? or Tags.name LIKE ? ',
                                        "%#{params[:query]}%",  "%#{params[:query]}%")
  end
end