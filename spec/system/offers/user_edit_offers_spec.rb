describe 'Usuário acessa formulário de edição de oferta' do
  it 'e atualiza preço com sucesso' do
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
    format = Format.create!(name: 'Porção Giga gante')
    Offer.new(
      format: format,
      item: dish,
      price: 25
    )
    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'
    click_on 'Editar preço'
    fill_in 'Preço',	with: '50' 
    click_on 'Salvar'
    # Assert
    expect(page).to have_content 'Porção atualizada com sucesso'
    expect(page).to have_content 'Porção Giga gante: R$ 50,00'
  end
end