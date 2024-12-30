class SearchController < ApplicationController
  before_action :employee?, only: [:search]

  def search
    search_item
    @count = @beverages.length + @dishes.length
  end

  def search_order
    @order = Order.find_by(code: params[:query])
  end

  private

  def search_item
    if params[:type] == 'Bebida'
      search_beverages
      @dishes = []
    elsif params[:type] == 'Comida'
      search_dishes
      @beverages = []
    else
      search_beverages
      search_dishes
    end
  end

  def search_beverages
    @beverages = Beverage.where('name LIKE ? or description LIKE ? ',
                                "%#{params[:query]}%", "%#{params[:query]}%")
  end

  def search_dishes
    @dishes = Dish.left_joins(:tags).where('Dishes.name LIKE ? or Tags.name LIKE ? ',
                                           "%#{params[:query]}%", "%#{params[:query]}%")
  end
end
