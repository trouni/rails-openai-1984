require 'open-uri'

class Illustration < ApplicationRecord
  after_commit :generate_image, on: :create, unless: -> { images.attached? }

  has_one_attached :character_photo
  has_many_attached :images

  validates :situation, presence: true
  # validates :character_photo, presence: true

  def generate_image
    character_description = DescribePhoto.new(character_photo.url).call
    detailed_situation = GenerateSituation.new(character_description, situation).call
    image_url = GenerateImage.new(detailed_situation).call
    attach_image_from_url(image_url)
  end

  private

  def attach_image_from_url(url)
    images.attach(io: URI.open(url), filename: "heroifyme_#{SecureRandom.hex(8)}.png")
  end
end
