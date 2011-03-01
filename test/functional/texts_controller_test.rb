require 'test_helper'

class TextsControllerTest < ActionController::TestCase
  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get harvest" do
    get :harvest
    assert_response :success
  end

  test "should get reset" do
    get :reset
    assert_response :success
  end

end
