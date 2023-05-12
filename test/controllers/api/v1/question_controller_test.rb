require "test_helper"

class Api::V1::QuestionControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_question_create_url
    assert_response :success
  end

  test "should calculate dot product" do
    controller = Api::V1::QuestionController.new

    assert controller.send(:calculate_similarity, [1,2], [3, 4]) == 11
  end
end
