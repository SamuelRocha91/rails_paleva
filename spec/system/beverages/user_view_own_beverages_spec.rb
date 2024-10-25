require 'rails_helper'

describe 'Usuário vê suas próprias bebidas' do

  it 'e navega para a página de detalhes' do
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

    beverage = Beverage.create!(name: 'Cachaça', description: 'alcool delicioso baiano', 
                 calories: '185', establishment: establishment, is_alcoholic: true)
    beverage.image.attach(io: File.open(Rails.root.join('spec', 'support', 'pao.jpg')), filename: 'pao.jpg')

    Beverage.create!(name: 'Suco da embasa', description: 'Água que mata a sede', calories: '1', establishment: establishment, is_alcoholic: false)
    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'

    # Assert
    expect(current_path).to eq establishment_beverage_path(establishment.id, beverage.id)
    expect(page).to have_content 'Nome: Cachaça'
    expect(page).to have_content 'Descrição: alcool delicioso baiano'
    expect(page).to have_css('img[src*="pao.jpg"]')
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_content 'É alcoólica? Sim'
    expect(page).to have_link 'Editar bebida'  
    expect(page).to have_button 'Excluir bebida'  
  end 
end