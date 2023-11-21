class CharactersController < ApplicationController
  before_action :set_character, only: %i[ show edit update destroy ]

  def index
    @characters = Character.all
  end

  def show
  end

  def new
    @character = Character.new
  end

  def edit
  end

  def create
    @character = Character.new(character_params)
    @character.user = current_user

    if @character.save
      redirect_to @character, notice: "Character was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @character.update(character_params)
      redirect_to @character, notice: "Character was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @character.destroy
    redirect_to characters_url, notice: "Character was successfully destroyed.", status: :see_other
  end

  private
    def set_character
      @character = Character.find(params[:id])
    end

    def character_params
      params.require(:character).permit(:description)
    end
end
