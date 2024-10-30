require 'rails_helper'

describe 'Usuário edita um prato' do
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

    dish = Dish.create!(
      name: 'lasagna', 
      description: 'pão com ovo', 
      calories: '185', 
      establishment: establishment
    )
    
    # Act
    visit edit_establishment_dish_path(establishment.id, dish.id)
    # Assert
    expect(current_path).to eq new_user_session_path  
  end

  it 'e vê página de detalhes com botão de editar e de atualizar status' do
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
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )
    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'
    # Assert
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: massa, queijo e presunto'
    expect(page).to have_content 'Status: Ativo'
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_button 'Desativar Prato'
  end

  it 'e desativa um prato' do
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
      description: 'massa, queijo e presunto', 
      calories: '185',
      establishment: establishment
    )
    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'
    click_on 'Desativar Prato'
    # Assert
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: massa, queijo e presunto'
    expect(page).to have_content 'Status: Inativo'
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_button 'Ativar Prato'
  end

   it 'e ativa um prato' do
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
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment, 
      status: false
    )
    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'
    click_on 'Ativar Prato'
    # Assert
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: massa, queijo e presunto'
    expect(page).to have_content 'Status: Ativo'
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_button 'Desativar Prato'
  end

  it 'com sucesso' do
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
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )
    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'
    click_on 'Editar prato'
    fill_in 'Nome',	with: 'Pão com ovo'
    fill_in 'Descrição',	with: 'ovo de galinha 10 reais'
    fill_in 'Quantidade de calorias',	with: '105'
    click_on 'Salvar'
    # Assert
    expect(page).to have_content 'Prato atualizado com sucesso'
    expect(page).to have_content 'Nome: Pão com ovo'
    expect(page).to have_content 'Descrição: ovo de galinha 10 reais'
    expect(page).not_to have_content 'lasagna'
    expect(page).not_to have_content 'massa, queijo e presunto'
  end

  it 'Caso seja o responsável' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )

    user_two = User.create!(
      first_name: 'Bill', 
      last_name: 'Gates', 
      email: 'ng@hotmail.com', 
      password: '12345678910111',  
      cpf: CPF.generate
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

    Establishment.create!(
      email: 'bill@gmail.com', 
      trade_name: 'Microsoft', 
      legal_name: 'Microsoft LTDA', 
      cnpj: '12345678000195',
      phone_number: '71992594950', 
      address: 'Rua da Microsoft',
      user: user_two
    )

    dish = Dish.create!(
      name: 'lasagna', 
      description: 'pão com ovo', 
      calories: '185', 
      establishment: establishment
    )
    # Act
    login_as user_two
    visit establishment_dish_path(establishment.id, dish.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a esse prato'
  end
end