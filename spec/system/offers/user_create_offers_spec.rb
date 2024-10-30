require 'rails_helper'

describe 'Usuário acessa formulário de criar oferta' do
  it 'e vê os campos corretamente' do
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
    Dish.create!(
      name: 'lasagna', 
      description: 'pão com ovo', 
      calories: '185', 
      establishment: establishment
    )

    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'
    click_on 'Cadastrar Porção'

    # Assert
    expect(page).to have_content 'Cadastro de porção de lasagna'
    expect(page).to have_field 'Nome da porção:'
    expect(page).to have_field 'Detalhes da porção:'
    expect(page).to have_field 'Preço da porção:'
    expect(page).to have_button 'Salvar'
  end
end