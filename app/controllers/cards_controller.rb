class CardsController < ApplicationController
  def index
    @cards = Card.order(review_date: :desc).all
  end
end
