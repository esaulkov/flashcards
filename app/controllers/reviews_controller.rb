class ReviewsController < ApplicationController
  def new
    @card = current_user.card_for_review
  end

  def create
    @card = Card.find(review_params[:card_id])
    @results = @card.check_answer(review_params[:answer],
                                  review_params[:answer_time])
    respond_to do |format|
      format.js do
        if @results[:success]
          flash.now[:notice] = t(:right_answer, card_text: @card.original_text)
          if @results[:typos] > 0
            flash.now[:notice] += t(:typo_message, answer: review_params[:answer])
          end
        elsif @card.attempt > 0
          flash.now[:error] = t(:next_try)
        else
          flash.now[:error] = t(:mistake_message, card_text: @card.original_text)
        end
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:card_id, :answer, :answer_time)
  end
end
