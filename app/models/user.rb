class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :is_valid_cpf? 
  validates :cpf, :first_name, :last_name, presence: true
  validates :cpf, uniqueness: true
  belongs_to :establishment, optional: true
  enum role: { admin: 0, employee: 1 }
  before_validation :set_establishment_from_temp_user, on: :create

  def description
    "#{first_name} #{last_name} - #{email}"
  end

  private

  def is_valid_cpf?
    if self.cpf.present? && !CPF.valid?(cpf)
      self.errors.add :cpf, " deve ser um número válido"
    end
  end

  def set_establishment_from_temp_user
    temp_user = TemporaryUser.find_by(email: self.email, cpf: self.cpf)
    if temp_user.present?
      self.establishment_id = temp_user.establishment_id
      self.role = :employee
      temp_user.destroy
    end
  end

end
