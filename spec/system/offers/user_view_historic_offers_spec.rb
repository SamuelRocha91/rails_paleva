require 'rails_helper'

describe 'Usuário acessa página de detalhes de item' do
  it 'e consegue ver histórico de ofertas' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
      user: user
    )
    dish = Dish.create!(
      name: 'lasagna', 
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )
    format = Format.create!(name: 'Porção Giga gante')
    format_two = Format.create!(name: 'Porção média')
    format_three = Format.create!(name: 'Porção pequena')

    Offer.create!(
      format: format,
      item: dish,
      price: 30,
      active: false,
      end_offer: "2064-12-31 15:45:22",
    )

    Offer.create!(
      format: format_two,
      item: dish,
      price: 25,
      active: false,
      end_offer: "2064-12-31 15:45:22"
    )

    Offer.create!(
      format: format_three,
      item: dish,
      price: 25,
      active: true,
      end_offer: "2064-12-31 15:45:22"
    )

    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'

    # Assert
    expect(page).to have_content 'Histórico'
    within('table') do
      expect(page).to have_content 'Nome da porção'
      expect(page).to have_content 'Data de início' 
      expect(page).to have_content'Data de término' 
      expect(page).to have_content 'Preço' 
      expect(page).to have_content 'Porção Giga gante'
      expect(page).to have_content 'Porção média'  
      expect(page).to have_content '31-12-2064'  
      expect(page).to have_content 'R$ 25,00'  
      expect(page).to have_content 'R$ 30,00'  
      expect(page).not_to have_content 'Porção pequena'  
    end
  end
end