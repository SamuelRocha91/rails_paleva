class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def valid_email?
    regex = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i
    return unless email && !email.match?(regex)

    errors.add :base, 'E-mail deve ser válido'
  end

  def valid_cpf?
    return unless cpf.present? && cpf.length.positive? && !CPF.valid?(cpf)

    errors.add :base, 'CPF deve ser um número válido'
  end
end
