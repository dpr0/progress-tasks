class Task < ActiveRecord::Base
  has_and_belongs_to_many :users

  include Workflow
  workflow_column :state
  workflow do
    state :new do
      event :start, transitions_to: :started
    end
    state :started do
      event :finish, transitions_to: :finished
    end
    state :finished do
      event :start, transitions_to: :started
    end
  end

  # validates :user,        presence: true
  validates :title,       presence: true
  validates :description, presence: true, length: { minimum: 2, maximum: 1000 }
  validates :state,       presence: true, inclusion: { in: %w(new started finished) }

  def change_state
    can_finish? ? finish! : start!
  end
end
