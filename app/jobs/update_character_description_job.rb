class UpdateCharacterDescriptionJob < ApplicationJob
  queue_as :default

  def perform(character_id)
    character = Character.find(character_id)
    character_description = DescribePhoto.new(character.photo.url).call
    character.update(description: character_description)
  end
end
