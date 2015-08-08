class ReviewsController < ApplicationController
  def new
    @card = current_user.card_for_review
  end

  def create
    card = Card.find(review_params[:card_id])
    if card.check_answer(review_params[:answer])
      redirect_to new_review_path, notice: "Верный ответ!"
    else
      flash[:error] = "Вы ошиблись! Правильный ответ - #{card.original_text}"
      redirect_to new_review_path
    end
  end

  private

  def review_params
    params.require(:review).permit(:card_id, :answer)
  end
end
