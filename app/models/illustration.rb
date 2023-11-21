require 'open-uri'

class Illustration < ApplicationRecord
  belongs_to :user

  after_commit :generate_image, on: :create

  def generate_image
    character_description = DescribeImage.new(character_photo_url).call
    detailed_situation = GenerateSituation.new(character_description, situation).call
    image_url = GenerateImage.new(detailed_situation).call
    update!(image_url: image_url)
  end
end
