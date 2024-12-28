require 'rails_helper'

describe 'Usuário acessa formulário de edição de oferta prato' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com',
      trade_name: 'Samsung',
      legal_name: 'Samsung LTDA',
      cnpj: '56924048000140',
      phone_number: '71992594946',
      address: 'Rua das Alamedas avenidas'
    )
    User.create!(
      first_name: 'Samuel',
      last_name: 'Rocha',
      email: 'samuel@hotmail.com',
      password: '12345678910111',
      cpf: '22611819572',
      establishment: establishment
    )
    dish = Dish.create!(
      name: 'lasagna',
      description: 'massa, queijo e presunto',
      calories: '185',
      establishment: establishment
    )
    format = Format.create!(name: 'Porção Giga gante')
    offer = Offer.create!(
      format: format,
      item: dish,
      price: 25
    )

    # Act
    visit edit_offer_dish_path(dish.id, offer.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ser :admin' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com',
      trade_name: 'Samsung',
      legal_name: 'Samsung LTDA',
      cnpj: '56924048000140',
      phone_number: '71992594946',
      address: 'Rua das Alamedas avenidas'
    )
    user = User.create!(
      first_name: 'Samuel',
      last_name: 'Rocha',
      email: 'samuel@hotmail.com',
      password: '12345678910111',
      cpf: '22611819572',
      establishment: establishment,
      role: 1
    )
    dish = Dish.create!(
      name: 'lasagna',
      description: 'massa, queijo e presunto',
      calories: '185',
      establishment: establishment
    )
    format = Format.create!(name: 'Porção Giga gante')
    offer = Offer.create!(
      format: format,
      item: dish,
      price: 25
    )

    # Act
    login_as user
    visit edit_offer_dish_path(dish.id, offer.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e falha por ausência de campo obrigatório' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com',
      trade_name: 'Samsung',
      legal_name: 'Samsung LTDA',
      cnpj: '56924048000140',
      phone_number: '71992594946',
      address: 'Rua das Alamedas avenidas'
    )
    user = User.create!(
      first_name: 'Samuel',
      last_name: 'Rocha',
      email: 'samuel@hotmail.com',
      password: '12345678910111',
      cpf: '22611819572',
      establishment: establishment
    )
    dish = Dish.create!(
      name: 'lasagna',
      description: 'massa, queijo e presunto',
      calories: '185',
      establishment: establishment
    )
    format = Format.create!(name: 'Porção Giga gante')
    Offer.create!(
      format: format,
      item: dish,
      price: 25
    )

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    click_on 'Editar Preço'
    fill_in 'Preço',	with: ''
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Preço não pode ficar em branco e deve ser maior que R$ 1,00'
  end

  it 'e atualiza preço com sucesso' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com',
      trade_name: 'Samsung',
      legal_name: 'Samsung LTDA',
      cnpj: '56924048000140',
      phone_number: '71992594946',
      address: 'Rua das Alamedas avenidas'
    )
    user = User.create!(
      first_name: 'Samuel',
      last_name: 'Rocha',
      email: 'samuel@hotmail.com',
      password: '12345678910111',
      cpf: '22611819572',
      establishment: establishment
    )
    dish = Dish.create!(
      name: 'lasagna',
      description: 'massa, queijo e presunto',
      calories: '185',
      establishment: establishment
    )
    format = Format.create!(name: 'Porção Giga gante')
    Offer.create!(
      format: format,
      item: dish,
      price: 25
    )

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    click_on 'Editar Preço'
    fill_in 'Preço', with: '50'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Porção atualizada com sucesso'
    expect(page).to have_content 'Porção Giga gante: R$ 50,00'
    expect(page).not_to have_content 'Porção Giga gante: R$ 25,00'
  end
end
