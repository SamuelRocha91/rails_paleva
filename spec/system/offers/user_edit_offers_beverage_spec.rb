require 'rails_helper'

describe 'Usuário acessa formulário de edição de oferta prato' do
  it 'e deve estar autenticado' do
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
    beverage = Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )
    format = Format.create!(name: 'Bombinha 50ml')
    offer = Offer.create!(
      format: format,
      item: beverage,
      price: 25
    )

    # Act
    visit edit_offer_beverage_path(beverage.id, offer.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end