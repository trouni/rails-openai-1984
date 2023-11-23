class IllustrationsController < ApplicationController
  def create
    @character = Character.find(params[:character_id])
    detailed_situation = GenerateSituation.new(@character.description, params[:situation]).call
    illustration_url = GenerateIllustration.new(detailed_situation).call
    @character.attach_illustration_from_url(illustration_url)
    redirect_to character_path(@character)
  end
  
  def destroy
    @illustration = ActiveStorage::Attachment.find(params[:id])
    @character = @illustration.record
    @illustration.purge
    redirect_to character_path(@character)
  end

  private

  def character_params
    params.require(:character).permit(:photo)
  end
end
