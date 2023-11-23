class GenerateIllustrationJob < ApplicationJob
  queue_as :default

  def perform(character_id, situation)
    character = Character.find(character_id)

    detailed_situation = GenerateSituation.new(character.description, situation).call
    illustration_url = GenerateIllustration.new(detailed_situation).call
    character.attach_illustration_from_url(illustration_url)
  end
end
