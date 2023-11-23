class PagesController < ApplicationController
  def home
    @illustrations = Character.with_attached_illustrations.order(created_at: :desc).map(&:illustrations).flatten.shuffle.first(20)
    @character = Character.new
  end
end
