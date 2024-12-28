require 'rails_helper'

describe 'Usuário acessa formulário de criar bebidas' do
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

    # Act
    visit new_establishment_beverage_path establishment.id

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

    # Act
    login_as user
    visit new_establishment_beverage_path establishment.id

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e vê os campos corretamente' do
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

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cadastrar nova bebida'

    # Assert
    expect(page).to have_content 'Cadastro de nova bebida'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Quantidade de calorias'
    expect(page).to have_field 'Imagem da bebida'
    expect(page).to have_field 'É alcoólica?'
    expect(page).to have_button 'Salvar'
  end

  it 'falha no cadastro por falta de campo obrigatório' do
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

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cadastrar nova bebida'
    fill_in 'Nome',	with: 'Cachaça'
    fill_in 'Quantidade de calorias',	with: '185'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Descrição não pode ficar em branco'
  end

  it 'e cadastra bebida com sucesso' do
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

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cadastrar nova bebida'
    fill_in 'Nome',	with: 'Cachaça'
    fill_in 'Quantidade de calorias',	with: '185'
    attach_file 'Imagem', Rails.root.join('spec/support/pao.jpg')
    check 'É alcoólica?'
    fill_in 'Descrição',	with: 'bebida forte 99 porcento alcool'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Bebida cadastrada com sucesso'
    expect(page).to have_content 'Nome: Cachaça'
    expect(page).to have_content 'Descrição: bebida forte 99 porcento alcool'
    expect(page).to have_content 'Status: Ativo'
  end
end
