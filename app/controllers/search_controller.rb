class SearchController < ApplicationController
  
  def search
    if params[:type] == 'Bebida'
      @beverages = Beverage.where('name LIKE ? or description LIKE ? ',
                                   "%#{params[:query]}%",  "%#{params[:query]}%")
      @count = @beverages.length
    elsif params[:type] == 'Comida'
      @dishes = Dish.where('name LIKE ? or description LIKE ? ',
                                   "%#{params[:query]}%",  "%#{params[:query]}%")
      @count = @dishes.length
    end
  end
end