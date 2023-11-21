class Illustration < ApplicationRecord
  belongs_to :character

  has_one_attached :image
end
