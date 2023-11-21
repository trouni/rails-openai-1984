class Character < ApplicationRecord
  belongs_to :user
  has_many :illustrations, dependent: :destroy

  has_one_attached :photo
end
