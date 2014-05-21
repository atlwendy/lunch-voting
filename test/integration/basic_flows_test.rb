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

  test "edit meeting members" do
    Capybara.current_driver = Capybara.javascript_driver
    visit('/meetings')

    assert page.has_content?("Sign in")
    fill_in 'session_email', with: 'bob@bob.com'
    fill_in 'session_password', with: 'testbob'
    click_button('Sign in')

    click_link('Show')
    assert_equal current_path, meeting_path(@meeting)
    assert page.has_content?('First Lunch')
    click_link('edit member')
    assert_equal current_path, 
     "#{meeting_path(@meeting)}/select_members"
    assert page.has_content?('Bob')
    assert page.has_content?('Annie')
    check('Bob')
    fill_in 'temail', with: 'xyz@abc.com'
    assert page.has_field?("temail", :with=>"xyz@abc.com")
    click_button('Add member')
    assert_equal page.evaluate_script('document.getElementById("addeduser").value'), 'xyz@abc.com'
    click_button('Save')
    assert_equal current_path, meeting_path(@meeting)
    assert page.has_content?('Bob')
    assert page.has_content?('xyz@abc.com')
  end

  test "edit restaurants" do
    Capybara.current_driver = Capybara.javascript_driver
    visit('/meetings')

    assert page.has_content?("Sign in")
    fill_in 'session_email', with: 'bob@bob.com'
    fill_in 'session_password', with: 'testbob'
    click_button('Sign in')

    click_link('Show')
    click_link('edit restaurant')
    assert_equal current_path, "#{meeting_path(@meeting)}/select_restaurants"
    assert page.has_content?('Chipotle')
    check('Chipotle')
    fill_in 'trest', with: 'canton cooks'
    assert page.has_field?('trest', :with=>'canton cooks')
    click_button('Add restaurant')
    assert_equal page.evaluate_script('document.getElementById("addedrest").value'), 'canton cooks'
    click_button('Save')
    assert_equal current_path, meeting_path(@meeting)
    assert page.has_content?('Chipotle')
    assert page.has_content?('canton cooks')
  end

  test "edit user" do
    Capybara.current_driver = Capybara.javascript_driver
    visit('/users')

    assert page.has_content?("Sign in")
    fill_in 'session_email', with: 'bob@bob.com'
    fill_in 'session_password', with: 'testbob'
    click_button('Sign in')

    click_link('Show')
    assert_equal current_path, user_path(@user)
    assert page.has_content?('Annie')
    click_link('Edit')
    assert_equal current_path, edit_user_path(@user)
    fill_in 'user_username', with: 'Marty'
    sleep 3
    click_button('Update User')
    sleep 2
    assert_equal current_path, user_path(@user)
    assert page.has_content?('Marty')
  end

  test "link to meeting from user" do
    @user.meetings = [@meeting]
    visit("/users/#{@user.id}")

    assert page.has_content?("Sign in")
    fill_in 'session_email', with: 'bob@bob.com'
    fill_in 'session_password', with: 'testbob'
    click_button('Sign in')

    click_link('First Lunch')
    assert_equal current_path, meeting_path(@meeting)
  end

  test "edit meeting" do
    Capybara.current_driver = Capybara.javascript_driver
    visit('/meetings')
    assert page.has_content?("Sign in")
    fill_in 'session_email', with: 'bob@bob.com'
    fill_in 'session_password', with: 'testbob'
    click_button('Sign in')

    click_link('Edit')

    assert_equal current_path, edit_meeting_path(@meeting)
    assert page.has_field?("title", :with=>"First Lunch")
    fill_in 'title', with: 'editing First Lunch'
    
    click_button('Update Meeting')
    assert_equal current_path, meeting_path(@meeting)
    assert page.has_content?('editing First Lunch')
  end

  test "create meeting" do
    Capybara.current_driver = Capybara.javascript_driver
    visit("/meetings/new")
    assert page.has_content?("Sign in")
    fill_in 'session_email', with: 'bob@bob.com'
    fill_in 'session_password', with: 'testbob'
    click_button('Sign in')

    fill_in 'title', with: 'Test Lunch'
    fill_in 'temail', with: 'bob@bob.com'
    assert page.has_field?("temail", :with=>"bob@bob.com")
    click_button('Add member')
    assert_equal page.evaluate_script('document.getElementById("addeduser").value'), 'bob@bob.com'
    
    fill_in 'trest', with: 'canton cooks'
    assert page.has_field?('trest', :with=>'canton cooks')
    click_button('Add restaurant')
    assert_equal page.evaluate_script('document.getElementById("addedrest").value'), 'canton cooks'
 
    click_button('Create Meeting')
    assert page.has_content?('Test Lunch')
    assert page.has_content?("Bob")
    assert page.has_content?("canton cooks")
    
    # uri = URI.parse(current_url)
    # newuri = "#{uri}?user=xyz@abc.com"
    # visit(uri)
    find("#uparrow1").click
    
    votes = page.all('table td#vnumber1').map(&:text)
    assert_equal votes,['1']    

    find("#downarrow1").click
    votes = page.all('table td#vnumber1').map(&:text)
    assert_equal votes, ['0']

  end

end
