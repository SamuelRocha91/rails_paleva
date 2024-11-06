require 'rails_helper'

describe 'Usuário acessa formulário de cadastro de cardápio' do
  it 'e deve estar autenticado' do
    # Act
    visit new_menu_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end