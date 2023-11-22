class PagesController < ApplicationController
  def home
    @illustrations = Character.with_attached_illustrations.order(created_at: :desc).limit(18).map(&:illustrations).flatten
    @character = Character.new
  end
end
