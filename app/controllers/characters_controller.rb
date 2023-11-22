class CharactersController < ApplicationController
  def create
    @character = Character.new(character_params)

    if @character.save!
      redirect_to character_path(@character)
    else
      render 'pages/home'
    end
  end

  def show
    @character = Character.find(params[:id])
    @illustrations = @character.illustrations.order(created_at: :desc).limit(18)
  end

  private

  def character_params
    params.require(:character).permit(:description)
  end
end
