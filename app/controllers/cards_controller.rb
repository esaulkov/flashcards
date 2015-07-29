class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  def index
    @cards = Card.order(review_date: :desc).all
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)

    if @card.save
      redirect_to cards_path, notice: "Карточка успешно создана"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to cards_path, notice: "Карточка успешно изменена"
    else
      render :edit
    end
  end

  def destroy
    @card.destroy
    redirect_to cards_path, notice: "Карточка удалена"
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text,
      :review_date, :user_id)
  end
end
