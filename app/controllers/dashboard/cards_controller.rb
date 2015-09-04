class Dashboard::CardsController < Dashboard::BaseController
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
      redirect_to dashboard_cards_path, notice: t(:card_creation)
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
      redirect_to dashboard_cards_path, notice: t(:card_change)
    else
      render :edit
    end
  end

  def destroy
    @card.destroy
    redirect_to dashboard_cards_path, notice: t(:card_destroy)
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def create_deck
    new_deck = deck_params[:new_deck_name]
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
    params.permit(:new_deck_name)
  end
end
