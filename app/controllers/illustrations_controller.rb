class IllustrationsController < ApplicationController
  def create
    # 1. Find the character
    @character = Character.find(params[:character_id])

    # 2. Generate the prompt for the illustration
    detailed_situation = GenerateSituation.new(@character.description, params[:situation]).call

    # 3. Generate the illustration
    illustration_url = GenerateIllustration.new(detailed_situation).call

    # 4. Attach the illustration to the character
    @character.attach_illustration_from_url(illustration_url)

    # 5. Redirect to the character show page
    redirect_to character_path(@character)
  end

  def destroy
    @illustration = ActiveStorage::Attachment.find(params[:id])
    @character = @illustration.record
    @illustration.purge
    redirect_to character_path(@character), notice: 'The illustration has been deleted!'
  end
end
