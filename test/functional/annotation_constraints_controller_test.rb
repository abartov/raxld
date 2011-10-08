require 'test_helper'

class AnnotationConstraintsControllerTest < ActionController::TestCase
  setup do
    @annotation_constraint = annotation_constraints(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:annotation_constraints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create annotation_constraint" do
    assert_difference('AnnotationConstraint.count') do
      post :create, annotation_constraint: @annotation_constraint.attributes
    end

    assert_redirected_to annotation_constraint_path(assigns(:annotation_constraint))
  end

  test "should show annotation_constraint" do
    get :show, id: @annotation_constraint.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @annotation_constraint.to_param
    assert_response :success
  end

  test "should update annotation_constraint" do
    put :update, id: @annotation_constraint.to_param, annotation_constraint: @annotation_constraint.attributes
    assert_redirected_to annotation_constraint_path(assigns(:annotation_constraint))
  end

  test "should destroy annotation_constraint" do
    assert_difference('AnnotationConstraint.count', -1) do
      delete :destroy, id: @annotation_constraint.to_param
    end

    assert_redirected_to annotation_constraints_path
  end
end
