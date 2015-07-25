class ReviewsController < ApplicationController
  def new
    @card = Card.expired.random.first
  end

  def create
    @card = Card.find(params[:card][:id])
    if @card.check_answer(params[:answer])
      redirect_to new_review_path, notice: "Верный ответ!"
    else
      flash[:error] = "Вы ошиблись! Правильный ответ - #{@card.original_text}"
      redirect_to new_review_path
    end
  end
end
