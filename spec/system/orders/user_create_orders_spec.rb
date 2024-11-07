require 'rails_helper'

describe 'Usuário cadastra um pedido' do
  it 'e deve estar autenticado' do
    # ACT
    visit new_order_path
    # Assert
    expect(current_path).to eq new_user_session_path  
  end
end