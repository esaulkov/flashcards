class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  before_action :create_deck, only: [:create, :update]
  def index
    @cards = current_user.cards.order(review_date: :desc).all
  end

  def new
    @card = current_user.cards.new
  end

  def create
    @card = current_user.cards.new(card_params)

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

  def create_deck
    new_deck = deck_params[:new_deck]
    if new_deck.present?
      deck = current_user.decks.create(name: new_deck)
      params[:card][:deck_id] = deck.id
    end
  end

  def card_params
    params.require(:card).permit(
      :original_text, :translated_text, :review_date, :deck_id, :image
    )
  end

  def deck_params
    params.require(:deck).permit(:new_deck)
  end
end
