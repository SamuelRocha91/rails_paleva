class Customer < ApplicationRecord
  validate :required_field
  validate :valid_email?
  validate :is_valid_cpf?
  validate :is_valid_phone_number?

  private

  def required_field
    if (!self.email || self.email.empty?) && 
         (!self.phone_number || self.phone_number.empty?)
      self.errors.add :base, 'E-mail ou telefone deve ser preenchido'
    end
  end

  def is_valid_phone_number?
    if self.phone_number.present? && self.phone_number.length > 0
      if self.phone_number.length > 11 || self.phone_number.length < 10
        self.errors.add :base, 'Telefone deve ser um número válido'
      end
    end
  end
end
