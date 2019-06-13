class Issue < ApplicationRecord
  enum actions: [:open, :closed]
end
