class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: %i[show index new update edit]
  before_action :set_dish, only: %i[ edit show update deactivate activate offer create_offer edit_offer update_offer
                                     deactivate_offer ]
  before_action :employee?
  before_action :set_format, only: [:create_offer]
  before_action :set_offer, only: %i[edit_offer update_offer deactivate_offer]

  def index
    @dishes = current_user.establishment.dishes
  end

  def new
    @dish = Dish.new
  end

  def create
    @dish = Dish.new(dish_params)
    @dish.establishment = Establishment.find(params[:establishment_id])
    if @dish.save
      save_tags if params[:dish][:tag_names].present?
      redirect_to establishment_dishes_path, notice: 'Prato cadastrado com sucesso'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    return unless @dish.update(dish_params)

    save_tags if params[:dish][:tag_names].present?
    redirect_to establishment_dish_path(current_user.establishment, @dish), notice: 'Prato atualizado com sucesso'
  end

  def deactivate
    @dish.update(status: false)
    redirect_to establishment_dish_path(@dish.establishment, @dish)
  end

  def activate
    @dish.update(status: true)
    redirect_to establishment_dish_path(@dish.establishment, @dish)
  end

  def offer
    @format = Format.new
  end

  def create_offer
    if @dish.portions.any? { |portion| portion.active && (portion.format.name == @format.name) }
      flash[:alert] = 'Não é possível cadastrar porções idênticas para o mesmo prato'
      render :offer, status: :unprocessable_entity
    else
      create_portion 'Porção cadastrada com sucesso'
    end
  end

  def edit_offer; end

  def update_offer
    return unless @offer.update(active: false)

    @format = Format.find_by(name: params[:format][:name])
    create_portion 'Porção atualizada com sucesso'
  end

  def deactivate_offer
    @offer.update(active: false)
    redirect_to establishment_dish_path(@dish.establishment, @dish)
  end

  private

  def dish_params
    params.require(:dish).permit(:name, :description, :image, :calories)
  end

  def check_user
    @establishment = Establishment.find(params[:establishment_id])
    return if @establishment.users.any? { |user| user.id == current_user.id }

    redirect_to root_path, notice: 'Você não possui acesso a esse prato'
  end

  def set_dish
    @dish = Dish.find(params[:id])
  end

  def set_offer
    @offer = Offer.find(params[:offer_id])
  end

  def create_portion(message)
    portion = @dish.portions
                   .new(format: @format, details: params[:offer][:details], price: params[:offer][:price].to_f.round(2))
    if portion.save
      redirect_to establishment_dish_path(@dish.establishment, @dish), notice: message
    else
      add_errors portion
      render :offer, status: :unprocessable_entity
    end
  end

  def save_tags
    tag_names = params[:dish][:tag_names].split(',').map(&:strip)
    tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
    @dish.tags = tags
  end

  def add_errors(portion)
    portion.errors.full_messages.each { |error_message| @dish.errors.add(:base, error_message) }
  end
end
