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

  def random
    @card = Card.expired.random
  end

  def check
    @card = Card.find(params[:card][:id])
    if @card.check_answer(params[:answer])
      @card.review_date = 3.days.from_now.to_date
      @card.save
      redirect_to random_cards_path, notice: "Верный ответ!"
    else
      flash[:error] = "Вы ошиблись! Правильный ответ - #{@card.original_text}"
      redirect_to random_cards_path
    end
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date)
  end
end
