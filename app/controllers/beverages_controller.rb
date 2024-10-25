class BeveragesController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @beverage = Beverage.new
  end
end