require 'rails_helper'

describe "Usuário acessa página de marcadores" do
  it 'e deve estar autenticado' do
    # Act
    visit tags_path
    # Assert
    expect(current_path).to eq new_user_session_path 
  end

  it 'e visualiza página corretamente' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
      user: user
    )
    Tag.create!(name: 'Apimentado')
    Tag.create!(name: 'Vegano')
    Tag.create!(name: 'Japonesa')
    Tag.create!(name: 'Massas')

    # Act
    login_as user
    visit root_path
    click_on 'Marcadores'
    # Assert
    expect(page).to have_content 'Marcadores Disponíveis'
    expect(page).to have_link 'Cadastrar novo marcador'
    expect(page).to have_content 'Apimentado'
    expect(page).to have_content 'Vegano'
    expect(page).to have_content 'Japonesa'
    expect(page).to have_content 'Massas'
  end

  it 'e visualiza mensagem instrutiva se não houver tags cadastradas' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
      user: user
    )

    # Act
    login_as user
    visit root_path
    click_on 'Marcadores'

    # Assert
    expect(page).to have_content 'Marcadores Disponíveis'
    expect(page).to have_content 'Não existem ainda marcadores cadastrados'
  end

  it 'e visualiza página de cadastro de tags corretamente' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
      user: user
    )

    # Act
    login_as user
    visit root_path
    click_on 'Marcadores'
    click_on 'Cadastrar novo marcador'

    # Assert
    expect(page).to have_content 'Cadastro de novo marcador'
    expect(page).to have_field 'Nome do marcador'
    expect(page).to have_button 'Salvar'
  end

  it 'e falha ao cadastrar marcador sem campo obrigatório' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
      user: user
    )

    # Act
    login_as user
    visit root_path
    click_on 'Marcadores'
    click_on 'Cadastrar novo marcador'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Nome do marcador não pode ficar em branco'
  end
end