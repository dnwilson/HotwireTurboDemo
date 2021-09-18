class BoardGame < ApplicationRecord
  validates :name, presence: true
end
