require 'test_helper'


class BasicFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all

 setup do
   @meeting = meetings(:one)
   @user = users(:two)
 end

 teardown do
   Capybara.use_default_driver
 end
=begin
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
    Capybara.current_driver = Capybara.javascript_driver
    visit('/meetings')
    click_link('Edit')

    assert_equal current_path, edit_meeting_path(@meeting)
    assert page.has_field?("title", :with=>"First Lunch")
    fill_in 'temail', with: 'xyz@abc.com'
    assert page.has_field?("temail", :with=>"xyz@abc.com")
    click_button('Add member')
    assert_equal page.evaluate_script('document.getElementById("addeduser").value'), 'xyz@abc.com'
    #assert_equal page.find("#thisid").value, "xyz@abc.com"
    fill_in 'trest', with: 'canton cooks'
    assert page.has_field?('trest', :with=>'canton cooks')
    click_button('Add restaurant')
    assert_equal page.evaluate_script('document.getElementById("addedrest").value'), 'canton cooks'
    click_button('Update Meeting')
    assert_equal current_path, meeting_path(@meeting)
    assert page.has_content?("xyz@abc.com")
    assert page.has_content?("canton cooks")
  end
=end
  test "create meeting" do
    Capybara.current_driver = Capybara.javascript_driver
    visit("/meetings/new")

    fill_in 'title', with: 'Test Lunch'
    fill_in 'temail', with: 'xyz@abc.com'
    assert page.has_field?("temail", :with=>"xyz@abc.com")
    click_button('Add member')
    assert_equal page.evaluate_script('document.getElementById("addeduser").value'), 'xyz@abc.com'
    #assert_equal page.find("#thisid").value, "xyz@abc.com"
    fill_in 'trest', with: 'canton cooks'
    assert page.has_field?('trest', :with=>'canton cooks')
    click_button('Add restaurant')
    assert_equal page.evaluate_script('document.getElementById("addedrest").value'), 'canton cooks'
 
    click_button('Create Meeting')
    assert page.has_content?('Test Lunch')
    assert page.has_content?("xyz@abc.com")
    assert page.has_content?("canton cooks")
    #find("#uparrow1").click
    #assert page.has_content?("You have to login")

    uri = URI.parse(current_url)
    puts uri
    newuri = "#{uri}?user=xyz@abc.com"
    visit(newuri)
    puts newuri
    find("#uparrow1").click
    #puts page.body
    votes = page.all('table td#vnumber1').map(&:text)
    votes.include?('1')
    #assert_equal page.evaluate_script('document.getELementById("vnumber1").value'), '1'
    #assert_equal page.evaluate_script('document.getElementById("vnumber1").value'), 1
    find("#downarrow1").click
    votes = page.all('table td#vnumber1').map(&:text)
    assert_equal votes, ['0']
  end

end
