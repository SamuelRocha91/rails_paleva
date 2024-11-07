class Customer < ApplicationRecord
  validate :required_field

  private

  def required_field
    if self.email.empty? && self.phone_number.empty?
      self.errors.add :base, 'E-mail ou telefone deve ser preenchido'
    end
  end
end
