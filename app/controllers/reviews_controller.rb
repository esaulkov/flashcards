class ReviewsController < ApplicationController
  def new
    @card = current_user.card_for_review
  end

  def create
    @card = Card.find(review_params[:card_id])
    answer_is_right, distance = @card.check_answer(review_params[:answer])
    if answer_is_right
      flash[:notice] = "Верный ответ! Это #{@card.original_text}."
      flash[:notice] += " Опечатка - #{review_params[:answer]}" if distance > 0
      redirect_to new_review_path
    elsif @card.attempt > 0
      flash.now[:error] = "Вы ошиблись! Попробуйте еще раз."
      render :new
    else
      flash[:error] = "Вы ошиблись! Правильный ответ - #{@card.original_text}"
      redirect_to new_review_path
    end
  end

  private

  def review_params
    params.require(:review).permit(:card_id, :answer)
  end
end
