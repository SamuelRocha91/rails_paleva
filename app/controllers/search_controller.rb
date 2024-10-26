class SearchController < ApplicationController
  
  def search
    if params[:type] == 'Bebida'
      @beverages = Beverage.where('name LIKE ? or description LIKE ? ', "%#{params[:query]}%",  "%#{params[:query]}%")
      @count = @beverages.length
    end
  end
end