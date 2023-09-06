class User < ApplicationRecord
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :boards
  has_many :cards, through: :boards
  has_many :lists, through: :boards
  has_many :tasks, through: :cards
end
