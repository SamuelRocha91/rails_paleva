class Establishment < ApplicationRecord
  validates :trade_name, :legal_name, :cnpj, :address,
             :phone_number, :email, presence: true
  belongs_to :user
  has_many :operating_hours
  accepts_nested_attributes_for :operating_hours
  validate :is_valid_cnpj?
  validate :is_valid_phone_number?
  validate :is_email_valid?

  private

  def is_valid_cnpj?
    if self.cnpj.present? && !(CNPJ.valid?(cnpj.to_i))
      self.errors.add :cnpj, " deve ser um número válido"
    end
  end

  def is_valid_phone_number?
    if self.phone_number.present? && phone_number.match?(/\D/)
      self.errors.add :phone_number, " deve ter apenas números"
    elsif phone_number.length < 10 || phone_number.length > 11
      self.errors.add :phone_number, " deve ser um número válido"
    end
  end

  def is_email_valid?
    regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    if self.email.present? && !email.match?(regex)
      self.errors.add :email, " deve ser um número válido"
    end
  end
end
