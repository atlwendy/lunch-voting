require 'test_helper'

class MeetingsControllerTest < ActionController::TestCase
  setup do
    @meeting = meetings(:one)
    @user = users(:one)
    @user['remember_token'] = 'da39a3ee5e6b4b0d3255bfef95601890afd80709'
    @user.save
    @user2 = users(:two)
  end

  def current_user
    @user
  end

  test "should get index" do
    current_user = @user
    get :index
    #assert_redirected_to "/signin"
    assert_response :success
    assert_not_nil assigns(:meetings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meeting" do
    assert_difference('Meeting.count') do
      post :create, meeting: { date: @meeting.date, description: @meeting.description, title: @meeting.title }
    end
    assert_redirected_to meeting_path(assigns(:meeting))
  end

  test "should show meeting" do
    get :show, id: @meeting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @meeting
    assert_response :success
  end

  test "should update meeting" do
    patch :update, id: @meeting, meeting: { date: @meeting.date, description: @meeting.description, title: @meeting.title }
    assert_redirected_to @meeting
  end

  test "should destroy meeting" do
    assert_difference('Meeting.count', -1) do
      delete :destroy, id: @meeting
    end

    assert_redirected_to meetings_path
  end

  test "should show select_members" do
    get :select_members, id: @meeting
    assert_response :success
  end

  test "should post submitted members" do
    assert_difference("Meeting.find(#{@meeting.id}).users.size", 1) do
      post :submit_members, id: @meeting, user_id: [@user.id, @user2.id]
    end
    assert_redirected_to @meeting
  end

end
