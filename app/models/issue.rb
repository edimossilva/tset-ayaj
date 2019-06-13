class Issue < ApplicationRecord
  enum actions: [:open, :closed]
  validates :action, presence: true
end
