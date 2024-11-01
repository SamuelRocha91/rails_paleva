class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end
end