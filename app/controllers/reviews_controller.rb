class ReviewsController < ApplicationController
  def new
    @card = current_user.card_for_review
  end

  def create
    @card = Card.find(review_params[:card_id])
    results = @card.check_answer(review_params[:answer])
    if results[:success]
      flash[:notice] = "Верный ответ! Это #{@card.original_text}."
      if results[:typos] > 0
        flash[:notice] += " Но у Вас опечатка - #{review_params[:answer]}"
      end
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
