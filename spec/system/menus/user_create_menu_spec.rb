require 'rails_helper'

describe 'Usuário acessa formulário de cadastro de cardápio' do
  it 'e deve estar autenticado' do
    # Act
    visit new_menu_path

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
      address: 'Rua das Alamedas avenidas',
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

    # Act
    login_as user
    visit new_menu_path

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
    expect(page).not_to have_link 'Cadastrar Cardápio'
  end

  it 'e visualiza campos corretamente' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
    )
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572',
      establishment: establishment
    )

    # Act
    login_as user
    visit root_path
    click_on 'Cadastrar cardápio'
    # Assert
    expect(page).to have_content 'Cadastro de Cardápio'
    expect(page).to have_field 'Nome do Cardápio'
    expect(page).to have_button 'Salvar'
  end

  it 'e falha ao tentar cadastrar sem nome' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
    )
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572',
      establishment: establishment
    )

    # Act
    login_as user
    visit root_path
    click_on 'Cadastrar cardápio'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Nome do Cardápio não pode ficar em branco'
  end

  it 'e cadastra com sucesso' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
    )
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572',
      establishment: establishment
    )

    # Act
    login_as user
    visit root_path
    click_on 'Cadastrar cardápio'
    fill_in 'Nome do Cardápio', with: 'Café da manhã'
    click_on 'Salvar'
    
    # Assert
    expect(page).to have_content 'Cardápio cadastrado com sucesso'
    expect(page).to have_content 'Café da manhã'
    expect(page).to have_link 'Adicionar Prato'
    expect(page).to have_content 'Adicionar Bebida'
  end

  it 'e falha ao preencher cardápio sazonal' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
    )
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572',
      establishment: establishment
    )

    # Act
    login_as user
    visit root_path
    click_on 'Cadastrar cardápio'
    fill_in 'Nome do Cardápio', with: 'Café da manhã'
    fill_in 'Início da validade',	with: 1.day.from_now
    click_on 'Salvar'
    
    # Assert
    expect(page).to have_content 'Término da validade deve estar presente no cadastro de pratos sazonais' 
  end
end