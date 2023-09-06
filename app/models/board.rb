class Board < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :destroy

  validates :title, presence: true
end


