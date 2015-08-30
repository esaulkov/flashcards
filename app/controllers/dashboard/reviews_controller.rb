class Dashboard::ReviewsController < Dashboard::ApplicationController
  def new
    @card = current_user.card_for_review
  end

  def create
    @card = Card.find(review_params[:card_id])
    @results = @card.check_answer(review_params[:answer],
                                  review_params[:answer_time])
    respond_to do |format|
      format.json do
        if @results[:success]
          notice = t(:right_answer, card_text: @card.original_text)
          if @results[:typos] > 0
            notice += t(:typo_message, answer: review_params[:answer])
          end
          render json: { message: notice, result: true }
        elsif @card.attempt > 0
          error = t(:next_try)
          render json: { message: error, reload: false, result: false }
        else
          error = t(:mistake_message, card_text: @card.original_text)
          render json: { message: error, reload: true, result: false }
        end
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:card_id, :answer, :answer_time)
  end
end
