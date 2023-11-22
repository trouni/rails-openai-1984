class IllustrationsController < ApplicationController
  def index
    @illustrations = Illustration.order(created_at: :desc)
  end

  def create
    @illustration = Illustration.new(illustration_params)

    if @illustration.save!
      redirect_to root_path
    else
      render 'pages/home'
    end
  end

  def show
    @illustration = Illustration.find(params[:id])
  end

  private

  def illustration_params
    params.require(:illustration).permit(:character_photo, :situation)
  end
end
