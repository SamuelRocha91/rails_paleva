require 'rails_helper'

describe "Usuário acessa página de marcadores" do
  it 'e deve estar autenticado' do
    # Act
    visit tags_path
    # Assert
    expect(current_path).to eq new_user_session_path 
  end
end