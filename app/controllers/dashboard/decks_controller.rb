class Dashboard::DecksController < Dashboard::ApplicationController
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
      redirect_to dashboard_decks_path, notice: t(:deck_creation)
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
      redirect_to dashboard_deck_path, notice: t(:deck_change)
    else
      render :edit
    end
  end

  def destroy
    @deck.destroy
    redirect_to dashboard_decks_path, notice: t(:deck_destroy)
  end

  def set_current
    if current_user.update(current_deck: @deck)
      flash[:notice] = t(:set_deck)
    else
      flash[:error] = t(:deck_is_not_set)
    end
    redirect_to dashboard_decks_path
  end

  private

  def set_deck
    @deck = Deck.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:name)
  end
end
