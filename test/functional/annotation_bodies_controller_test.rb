require 'test_helper'

class AnnotationBodiesControllerTest < ActionController::TestCase
  setup do
    @annotation_body = annotation_bodies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:annotation_bodies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create annotation_body" do
    assert_difference('AnnotationBody.count') do
      post :create, annotation_body: @annotation_body.attributes
    end

    assert_redirected_to annotation_body_path(assigns(:annotation_body))
  end

  test "should show annotation_body" do
    get :show, id: @annotation_body.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @annotation_body.to_param
    assert_response :success
  end

  test "should update annotation_body" do
    put :update, id: @annotation_body.to_param, annotation_body: @annotation_body.attributes
    assert_redirected_to annotation_body_path(assigns(:annotation_body))
  end

  test "should destroy annotation_body" do
    assert_difference('AnnotationBody.count', -1) do
      delete :destroy, id: @annotation_body.to_param
    end

    assert_redirected_to annotation_bodies_path
  end
end
