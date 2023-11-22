class PagesController < ApplicationController
  def home
    @images = Illustration.with_attached_images.order(created_at: :desc).limit(18).map(&:images).flatten
    @illustration = Illustration.new
  end
end
