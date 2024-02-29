class IllustrationsController < ApplicationController
  def destroy
    @illustration = ActiveStorage::Attachment.find(params[:id])
    @character = @illustration.record
    @illustration.purge
    redirect_to character_path(@character), notice: 'The illustration has been deleted!'
  end
end
