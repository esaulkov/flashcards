class ReviewsController < ApplicationController
  def new
    @card = current_user.card_for_review
  end

  def create
    @card = Card.find(review_params[:card_id])
    results = CheckAnswer.new(card: @card).
              call(review_params[:answer], review_params[:answer_time])
    if results[:success]
      flash[:notice] = t(:right_answer, card_text: @card.original_text)
      if results[:typos] > 0
        flash[:notice] += t(:typo_message, answer: review_params[:answer])
      end
      redirect_to new_review_path
    elsif @card.attempt > 0
      flash.now[:error] = t(:next_try)
      render :new
    else
      flash[:error] = t(:mistake_message, card_text: @card.original_text)
      redirect_to new_review_path
    end
  end

  private

  def review_params
    params.require(:review).permit(:card_id, :answer, :answer_time)
  end
end
