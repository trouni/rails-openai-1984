class Character < ApplicationRecord
  has_one_attached :photo
  has_many_attached :illustrations

  validates :photo, presence: true
end
