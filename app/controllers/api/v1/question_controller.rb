class Api::V1::QuestionController < ApplicationController
  def create
    question_input = question_param
    answer = "TODO: replace with OpenAI response"

    qa = QuestionAnswer.find_by(question: question_input)
    if qa.nil?
      qa = QuestionAnswer.create!(question: question_input, answer: answer)
    end

    render json: qa
  end

  private

  def question_param
    params.require(:question)
  end
end
