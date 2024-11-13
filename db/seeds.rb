# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#   

# Estabelecimento
establishment = Establishment.find_or_create_by(
  trade_name: 'Mata fome', 
  legal_name: 'Vô-LHE Engordar LTDA', 
  cnpj: '63539965000177', 
  phone_number: '71992594946', 
  email: 'xodesnuticao@gmail.com',
  address: 'Rua dos gordins, 1950'
)

# Vincular horário de funcionamento

operating_hour = []
6.times { |i| operating_hour << OperatingHour.new(
                                  week_day: i, 
                                  is_closed: true
                                  ) }
operating_hour <<  OperatingHour.new(
                                  week_day: 6, 
                                  start_time: Time.zone.parse('08:00'), 
                                  end_time: Time.zone.parse('22:00'), 
                                  is_closed: false
                                )
establishment.operating_hours = operating_hour

# Definindo a seed para o usuário :admin
User.find_or_create_by(
  email: 'urso@gmail.com',
  establishment_id: establishment.id,
  cpf: '03466798507',
  first_name: 'urso',
  last_name: 'panda'
) do |user|
  user.password = '1234567891234'
  user.password_confirmation = "1234567891234"
end

User.find_or_create_by(
  email: 'boimanso@gmail.com',
  establishment_id: establishment.id,
  cpf: '22611819572',
  first_name: 'boi',
  last_name: 'manso'
) do |user|
  user.password = '1234567891234'
  user.password_confirmation = "1234567891234"
  user.role = 1
end


# Tags
tag_vegetariano = Tag.find_or_create_by(name: 'Vegetariano')
Tag.find_or_create_by(name: 'Gluten Free')
tag_picante = Tag.find_or_create_by(name: 'Picante')
tag_dieta = Tag.find_or_create_by(name: 'Dieta')
tag_low_calorie = Tag.find_or_create_by(name: 'Low Calorie')

# Pratos
dish1 = Dish.find_or_create_by(
  name: 'Feijoada', 
  description: 'Feijão preto com carne de porco, arroz e farofa.', 
  calories: '850', 
  establishment_id: establishment.id
)

dish2 = Dish.find_or_create_by(
  name: 'Salada de Frango', 
  description: 'Peito de frango grelhado com legumes frescos.', 
  calories: '350', 
  establishment_id: establishment.id
)

dish3 = Dish.find_or_create_by(
  name: 'Strogonoff de Carne', 
  description: 'Carne em molho cremoso com arroz e batata palha.', 
  calories: '700', 
  establishment_id: establishment.id
)

dish4 = Dish.find_or_create_by(
  name: 'Moqueca de Peixe', 
  description: 'Peixe cozido com leite de coco e dendê.', 
  calories: '600', 
  establishment_id: establishment.id
)

dish5 = Dish.find_or_create_by(
  name: 'Hambúrguer Vegetariano', 
  description: 'Hambúrguer feito com ingredientes 100% vegetais.', 
  calories: '450', 
  establishment_id: establishment.id
)

# Associando tags aos pratos
DishTag.find_or_create_by(dish_id: dish1.id, tag_id: tag_picante.id)
DishTag.find_or_create_by(dish_id: dish2.id, tag_id: tag_vegetariano.id)
DishTag.find_or_create_by(dish_id: dish3.id, tag_id: tag_dieta.id)
DishTag.find_or_create_by(dish_id: dish4.id, tag_id: tag_low_calorie.id)
DishTag.find_or_create_by(dish_id: dish5.id, tag_id: tag_vegetariano.id)

# Bebidas
beverage1 = Beverage.find_or_create_by(
  name: 'Suco de Laranja', 
  description: 'Suco natural de laranja.',
  is_alcoholic: false, 
  calories: '120', 
  establishment_id: establishment.id
)

beverage2 = Beverage.find_or_create_by(
  name: 'Caipirinha', 
  description: 'Cachaça com limão, açúcar e gelo.',
  is_alcoholic: true, 
  calories: '300', 
  establishment_id: establishment.id
)

beverage3 = Beverage.find_or_create_by(
  name: 'Água Mineral', 
  description: 'Água fresca e purificada.',
  is_alcoholic: false, 
  calories: '0', 
  establishment_id: establishment.id
)

Beverage.find_or_create_by(
  name: 'Cerveja Artesanal', 
  description: 'Cerveja artesanal local.',
  is_alcoholic: true, 
  calories: '150', 
  establishment_id: establishment.id
)

Beverage.find_or_create_by(
  name: 'Refrigerante', 
  description: 'Refrigerante de cola.',
  is_alcoholic: false, 
  calories: '150', 
  establishment_id: establishment.id
)

# Ofertas de Pratos e Bebidas
format = Format.find_or_create_by(name: 'Promocional')

Offer.find_or_create_by(
  format: format, 
  item_type: 'Dish', 
  item_id: dish1.id, 
  price: 29.90, 
  start_offer: Time.zone.now, 
  end_offer: Time.zone.now + 1.week
)

Offer.find_or_create_by(
  format: format, 
  item_type: 'Dish', 
  item_id: dish2.id, 
  price: 19.90, 
  start_offer: Time.zone.now, 
  end_offer: Time.zone.now + 1.week
)

Offer.find_or_create_by(
  format: format, 
  item_type: 'Beverage', 
  item_id: beverage1.id, 
  price: 5.00, 
  start_offer: Time.zone.now, 
  end_offer: Time.zone.now + 1.week
)

Offer.find_or_create_by(
  format: format, 
  item_type: 'Beverage', 
  item_id: beverage2.id, 
  price: 12.50, 
  start_offer: Time.zone.now, 
  end_offer: Time.zone.now + 1.week
)

Offer.find_or_create_by(
  format: format, 
  item_type: 'Beverage', 
  item_id: beverage3.id, 
  price: 3.00, 
  start_offer: Time.zone.now, 
  end_offer: Time.zone.now + 1.week
)

p User.all