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

  test "link to meeting from user" do
    @user.meetings = [@meeting]
    visit("/users/#{@user.id}")
    click_link('First Lunch')
    assert_equal current_path, meeting_path(@meeting)
  end

  test "edit meeting" do
    visit('/meetings')
    click_link('Edit')
    assert_equal current_path, edit_meeting_path(@meeting)
    #find_field("title").value.should eq 'First Lunch'
    assert page.has_field?("title", :with=>"First Lunch")
    fill_in 'temail', with: 'xyz@abc.com'
    assert page.has_field?("temail", :with=>"xyz@abc.com")
    click_button('Add member')
    #find_field("thisid").value.should eq "xyz@abc.com"
    #assert page.has_field?("thisid", :with=>"xyz@abc.com")
  end

end
