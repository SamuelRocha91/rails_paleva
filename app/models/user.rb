class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :valid_cpf?
  validates :cpf, :first_name, :last_name, presence: true
  validates :cpf, uniqueness: true
  belongs_to :establishment, optional: true
  enum role: { admin: 0, employee: 1 }
  before_validation :set_establishment_from_temp_user, on: :create

  def description
    "#{first_name} #{last_name} - #{email}"
  end

  private

  def valid_cpf?
    return unless cpf.present? && !CPF.valid?(cpf)

    errors.add :cpf, ' deve ser um número válido'
  end

  def set_establishment_from_temp_user
    temp_user = TemporaryUser.find_by(email: email, cpf: cpf)
    return if temp_user.blank?

    self.establishment_id = temp_user.establishment_id
    self.role = :employee
    temp_user.destroy
  end
end
