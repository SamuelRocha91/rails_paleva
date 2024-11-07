class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :is_valid_cpf? 
  validates :cpf, :first_name, :last_name, presence: true
  validates :cpf, uniqueness: true
  has_one :establishment
  enum role: { admin: 0, buyer: 2 }


  def description
    "#{first_name} #{last_name} - #{email}"
  end

  private

  def is_valid_cpf?
    if self.cpf.present? && !CPF.valid?(cpf)
      self.errors.add :cpf, " deve ser um número válido"
    end
  end
end
