require 'test_helper'

class AnnotationTargetInfosControllerTest < ActionController::TestCase
  setup do
    @annotation_target_info = annotation_target_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:annotation_target_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create annotation_target_info" do
    assert_difference('AnnotationTargetInfo.count') do
      post :create, annotation_target_info: @annotation_target_info.attributes
    end

    assert_redirected_to annotation_target_info_path(assigns(:annotation_target_info))
  end

  test "should show annotation_target_info" do
    get :show, id: @annotation_target_info.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @annotation_target_info.to_param
    assert_response :success
  end

  test "should update annotation_target_info" do
    put :update, id: @annotation_target_info.to_param, annotation_target_info: @annotation_target_info.attributes
    assert_redirected_to annotation_target_info_path(assigns(:annotation_target_info))
  end

  test "should destroy annotation_target_info" do
    assert_difference('AnnotationTargetInfo.count', -1) do
      delete :destroy, id: @annotation_target_info.to_param
    end

    assert_redirected_to annotation_target_infos_path
  end
end
