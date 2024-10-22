require 'rails_helper'

describe "Usuário acessa a aplicação" do
  it 'não logado é direcionado para a página de login' do
    # Act
    visit root_path
    # Assert
    expect(current_path).to eq new_user_session_path 
  end
end
