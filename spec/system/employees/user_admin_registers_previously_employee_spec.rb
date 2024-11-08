require 'rails_helper'

describe "Usuário faz pré-cadastro de funcionários" do
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
        address: 'Rua dos mangabaubas',
        user: user
    )
    # Act
    visit employee_new_establishment_path establishment.id

    # Assert
    expect(current_path).to eq new_user_session_path 
  end
end