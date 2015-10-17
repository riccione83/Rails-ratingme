require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  setup do
    @rating = ratings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ratings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rating" do
    assert_difference('Rating.count') do
      post :create, rating: { description: @rating.description, point: @rating.point, rate_question1: @rating.rate_question1, rate_question2: @rating.rate_question2, rate_question3: @rating.rate_question3, review_id: @rating.review_id, user_id: @rating.user_id, user_name: @rating.user_name }
    end

    assert_redirected_to rating_path(assigns(:rating))
  end

  test "should show rating" do
    get :show, id: @rating
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rating
    assert_response :success
  end

  test "should update rating" do
    patch :update, id: @rating, rating: { description: @rating.description, point: @rating.point, rate_question1: @rating.rate_question1, rate_question2: @rating.rate_question2, rate_question3: @rating.rate_question3, review_id: @rating.review_id, user_id: @rating.user_id, user_name: @rating.user_name }
    assert_redirected_to rating_path(assigns(:rating))
  end

  test "should destroy rating" do
    assert_difference('Rating.count', -1) do
      delete :destroy, id: @rating
    end

    assert_redirected_to ratings_path
  end
end
