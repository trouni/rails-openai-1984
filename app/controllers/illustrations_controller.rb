class IllustrationsController < ApplicationController
  def create
    @character = Character.find(params[:character_id])
    GenerateIllustrationJob.perform_later(@character.id, params[:situation])

    redirect_to character_path(@character), notice: 'Your illustration is being generated...'
  end
  
  def destroy
    @illustration = ActiveStorage::Attachment.find(params[:id])
    @character = @illustration.record
    @illustration.purge
    redirect_to character_path(@character), notice: 'The illustration has been deleted!'
  end

  private

  def character_params
    params.require(:character).permit(:photo)
  end
end
