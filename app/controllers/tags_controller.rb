class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :employee?
  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(name: params[:tag][:name])
    if @tag.save
      redirect_to tags_path, notice: 'Marcador cadastrado com sucesso'
    else
      render :new, status: :unprocessable_entity
    end
  end
end