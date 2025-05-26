require "open-uri"

class Character < ApplicationRecord
  after_commit :generate_description, on: :create

  has_many_attached :illustrations
  has_one_attached :photo

  def attach_illustration_from_url(url)
    illustrations.attach(io: URI.open(url), filename: "heroifyme_#{SecureRandom.hex(8)}.png")
  end

  private

  def generate_description
    p photo.url
    character_description = DescribePhoto.new(photo.url).call
    update(description: character_description)
  end
end
