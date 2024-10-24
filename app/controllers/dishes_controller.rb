class DishesController < ApplicationController
  before_action :authenticate_user!
  
  def new
  end
end