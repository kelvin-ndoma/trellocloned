# app/models/task.rb
class Task < ApplicationRecord
  belongs_to :card

  enum status: {
    todo: 'To Do',
    doing: 'Doing',
    complete: 'Complete'
    # Add more statuses as needed
  }

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: Task.statuses.keys }
end



