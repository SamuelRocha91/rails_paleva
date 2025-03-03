require 'rails_helper'

describe 'Usuário edita seu estabelecimento' do
  it 'a partir da página home' do
    # Arrange
    establishment = FactoryBot.create(:establishment)
    user = create(:user, establishment: establishment)
    7.times do |i|
      create(:operating_hour, week_day: i, establishment: establishment)
    end

    # Act
    login_as user
    visit root_path
    click_on establishment.trade_name
    click_on 'Editar informações'

    # Assert
    expect(current_path).to eq edit_establishment_path establishment.id
    expect(page).to have_content 'Editar Restaurante'
    expect(page).to have_field 'Nome Social'
    expect(page).to have_field 'Nome Fantasia'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Telefone'
    expect(page).to have_field 'E-mail'
    expect(page).to have_content 'Horário de funcionamento'
    expect(page).to have_content 'Domingo'
    expect(page).to have_content 'Segunda'
    expect(page).to have_content 'Terça'
    expect(page).to have_content 'Quarta'
    expect(page).to have_content 'Quinta'
    expect(page).to have_content 'Sexta'
    expect(page).to have_content 'Sábado'
    expect(page).to have_button 'Salvar'
  end

  it 'com dados incompletos' do
    # Arrange
    establishment = FactoryBot.create(:establishment)
    user = create(:user, establishment: establishment)
    7.times do |i|
      create(:operating_hour, week_day: i, establishment: establishment)
    end

    # Act
    login_as user
    visit root_path
    click_on establishment.trade_name
    click_on 'Editar informações'
    fill_in 'Endereço',	with: ''
    fill_in 'Telefone',	with: ''
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Não foi possível atualizar o estabelecimento'
  end

  it 'com sucesso' do
    # Arrange
    establishment = FactoryBot.create(:establishment)
    user = create(:user, establishment: establishment)

    operating_hour = []
    6.times do |i|
      operating_hour << OperatingHour
                        .new(week_day: i, is_closed: true)
    end
    operating_hour << OperatingHour.new(
      week_day: 6,
      start_time: Time.zone.parse('08:00'),
      end_time: Time.zone.parse('22:00'),
      is_closed: false
    )

    establishment.operating_hours = operating_hour

    # Act
    login_as user
    visit root_path

    click_on establishment.trade_name
    click_on 'Editar informações'
    fill_in 'Endereço',	with: 'Rua nova das novidades'
    fill_in 'Telefone',	with: '85992594946'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Estabelecimento atualizado com sucesso'
    expect(page).to have_content "Código: #{establishment.code}"
    expect(page).to have_content 'Telefone: (85) 99259-4946'
    expect(page).to have_content 'Segunda: Fechado'
    expect(page).to have_content 'Terça: Fechado'
    expect(page).to have_content 'Sábado: 08:00 - 22:00'
    expect(page).to have_selector('dt', text: 'Segunda:', count: 1)
    expect(page).to have_selector('dt', text: 'Terça:', count: 1)
    expect(page).to have_selector('dt', text: 'Domingo:', count: 1)
  end
end
