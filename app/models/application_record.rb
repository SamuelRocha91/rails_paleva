class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

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

end
