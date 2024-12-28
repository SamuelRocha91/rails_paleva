class Customer < ApplicationRecord
  validate :required_field
  validate :valid_email?
  validate :valid_cpf?
  validate :valid_phone_number?

  private

  def required_field
    return unless email.blank? && phone_number.blank?

    errors.add :base, 'E-mail ou telefone deve ser preenchido'
  end

  def valid_phone_number?
    return unless phone_number.present? && phone_number.length.positive?

    return unless phone_number.length > 11 || phone_number.length < 10

    errors.add :base, 'Telefone deve ser um número válido'
  end
end
