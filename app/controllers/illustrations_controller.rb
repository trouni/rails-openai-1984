class IllustrationsController < ApplicationController
  def index
    @illustrations = current_user.illustrations.where.not(image_url: nil).order(created_at: :desc)
  end

  def create
    @illustration = Illustration.new(illustration_params)
    @illustration.user = current_user

    if @illustration.save!
      redirect_to illustrations_path
    else
      render :index
    end
  end

  def show
    @illustration = Illustration.find(params[:id])
  end

  private

  def illustration_params
    params.require(:illustration).permit(:character_photo_url, :situation)
  end
end
