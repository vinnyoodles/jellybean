class Api::V1::QuestionController < ApplicationController
  def create
    question_input = question_param
    answer = "TODO: replace with OpenAI response"
    qa = QuestionAnswer.create!(question: question_input, answer: answer)
    if qa
      render json: qa
    else
      render json: qa.errors
    end
  end

  private

  def question_param
    params.require(:question)
  end
end
