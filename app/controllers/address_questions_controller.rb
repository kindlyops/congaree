class AddressQuestionsController < QuestionsController
  def update
    if authorized_question.update(permitted_attributes(AddressQuestion))
      redirect_to survey_url, notice: "Nice! Question saved."
    else
      render :edit
    end
  end

  private

  def authorized_question
    authorize AddressQuestion.find(params[:id])
  end
end
