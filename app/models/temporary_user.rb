class TemporaryUser < ApplicationRecord
  belongs_to :establishment
  validate :is_valid_cpf?
  validate :valid_email?
  validates :cpf, uniqueness: true
  validate :cpf_must_be_unique_in_system 
  validate :email_must_be_unique_in_system 

  private 

  def cpf_must_be_unique_in_system 
    if User.exists?(cpf: cpf)
      errors.add(:cpf, 'já está em uso por um usuário existente')
    end 
  end
  
  def email_must_be_unique_in_system 
    if User.exists?(email: email)
      errors.add(:email, 'já está em uso por um usuário existente')
    end 
  end
end
