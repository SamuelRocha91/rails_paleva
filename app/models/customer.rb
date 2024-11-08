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

  def valid_email?
    regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    if self.email && !self.email.match?(regex)
       self.errors.add :base, 'E-mail deve ser válido'
    end
  end

  def is_valid_cpf?
    if self.cpf.present? && self.cpf.length > 0 && !CPF.valid?(cpf)
      self.errors.add :base, 'CPF deve ser um número válido'
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
