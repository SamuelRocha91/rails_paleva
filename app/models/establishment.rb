class Establishment < ApplicationRecord
  validates :trade_name, :legal_name, :cnpj, :address,
             :phone_number, :email, :code, presence: true

  before_validation :generate_code, on: :create
  belongs_to :user
  has_many :operating_hours, dependent: :destroy
  accepts_nested_attributes_for :operating_hours
  validate :is_valid_cnpj?
  validate :is_valid_phone_number?
  validate :is_email_valid?
  validate :validate_operating_hours_filled

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

  def validate_operating_hours_filled
    self.operating_hours.each do |operating_hour|

      week_day_name = I18n
        .t("activerecord.attributes.operating_hour.#{operating_hour.week_day}")
  
      if operating_hour.start_time.blank? || operating_hour.end_time.blank?
        if operating_hour.is_closed == false
          self.errors.add :operating_hours, 
                      "de #{week_day_name} deve ser definido ou marcado como fechado."
           next
        end
      end
      
      if operating_hour.is_closed == false && (operating_hour.start_time >= operating_hour.end_time)
         self.errors.add :operating_hours, 
                      "de #{week_day_name} deve ser definido corretamente(Hora de abertura deve ser menor que a de fechamento)."
      end
    end
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(6)
  end
end
