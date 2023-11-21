class IllustrationsController < ApplicationController
  def create
    @character = Character.find(params[:character_id])
    @illustration = Illustration.new(illustration_params)
    @illustration.character = @character

    if @illustration.save!
      redirect_to character_path(@illustration.character)
    else
      render "characters/show"
    end
  end

  def show
    @illustration = Illustration.find(params[:id])
  end

  private

  def illustration_params
    params.require(:illustration).permit(:situation)
  end
end
