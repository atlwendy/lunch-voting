require 'test_helper'

class BasicFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    @meeting = meetings(:one)
    @user = users(:two)
  end

  test "edit meeting members" do
    visit('/meetings')
    click_link('Show')
    assert_equal current_path, meeting_path(@meeting)
    assert page.has_content?('First Lunch')
    click_link('edit')
    assert_equal current_path, 
      "#{meeting_path(@meeting)}/select_members"
    assert page.has_content?('Bob')
    assert page.has_content?('Annie')
    check('Bob')
    click_button('Save')
    assert_equal current_path, meeting_path(@meeting)
    assert page.has_content?('Bob')
  end

  test "edit user" do
    visit('/users')
    click_link('Show')
    assert_equal current_path, user_path(@user)
    assert page.has_content?('Annie')
    click_link('Edit')
    assert_equal current_path, edit_user_path(@user)
    fill_in('Username', :with => 'Marty')
    click_button('Update User')
    assert_equal current_path, user_path(@user)
    assert page.has_content?('Marty')
  end
end
