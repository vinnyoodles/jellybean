require 'csv'
require 'json'
require 'openai'
require 'matrix'

OPENAI_COMPLETION_MODEL = "text-davinci-003"
OPENAI_EMBEDDINGS_MODEL = "text-embedding-ada-002"
EMBEDDINGS_FILENAME = ENV["EMBEDDINGS_CSV_FILE"]

STARTER_PROMPT = "John Steinbeck is an author that wrote the famous novel, Of Mice and Men."

class Api::V1::QuestionController < ApplicationController
  def create
    question_input = question_param

    qa = QuestionAnswer.find_by(question: question_input)
    if qa.nil?
      answer = answer_question(question_input)
      qa = QuestionAnswer.create!(question: question_input, answer: answer)
    end

    render json: qa
  end

  private
  def question_param
    params.require(:question)
  end

  # Use OpenAI completion API to answer the question by creating a prompt with
  # the question itself and the most similar text in the manuscript.
  # Similarity between two blurbs will be calculated with product of the
  # two embedding matrices.
  def answer_question(question)
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    question_embedding = client.embeddings(
        parameters: {
            model: OPENAI_EMBEDDINGS_MODEL,
            input: question
        }
    )

    similar_text = find_similar_text(question_embedding['data'][0]['embedding'])
    suffix = if question.end_with?("?") then "" else "?" end
    response = client.completions(
        parameters: {
            model: OPENAI_COMPLETION_MODEL,
            prompt: STARTER_PROMPT + similar_text + question + suffix,
            max_tokens: 150
        }
    )
    return response["choices"][0]["text"]
  end

  # Calculate the similarity between each row of the manuscript csv and the question.
  # Return the manuscript text yielding the highest similarity value.
  def find_similar_text(query_embedding)
    manuscript_embeddings = CSV.read(EMBEDDINGS_FILENAME)
    emb_idx = manuscript_embeddings[0].find_index('embedding')
    text_idx = manuscript_embeddings[0].find_index('text')
    embeddings = manuscript_embeddings.drop(1)
    # Remove the header and then calculate similarity
    similarities = embeddings.map { |emb| calculate_similarity(JSON.parse(emb[emb_idx]), query_embedding) }
    return embeddings[similarities.find_index(similarities.min)][text_idx]
  end

  # Use the dot product to calculate similarity.
  def calculate_similarity(emb_a, emb_b)
    a = Vector.send(:new, emb_a)
    b = Vector.send(:new, emb_b)
    return a.inner_product(b)
  end
end
