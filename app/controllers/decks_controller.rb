class DecksController < ApplicationController
  before_action :set_deck, except: [:index, :new, :create]

  def index
    @decks = current_user.decks.all.order(:name)
  end

  def new
    @deck = current_user.decks.new
  end

  def create
    @deck = current_user.decks.new(deck_params)

    if @deck.save
      redirect_to decks_path, notice: "Колода успешно создана"
    else
      render :new
    end
  end

  def show
    @cards = @deck.cards.all
  end

  def edit
  end

  def update
    if @deck.update(deck_params)
      redirect_to deck_path, "Колода успешно изменена"
    else
      render :edit
    end
  end

  def destroy
    @deck.destroy
    redirect_to decks_path, notice: "Колода удалена"
  end

  def set_current
    if current_user.update(current_deck: @deck)
      flash[:notice] = "Текущая колода установлена"
    else
      flash[:error] = "Не удалось установить текущую колоду"
    end
    redirect_to decks_path
  end

  private

  def set_deck
    @deck = Deck.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:name)
  end
end
