require 'test_helper'


class BasicFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    @meeting = meetings(:one)
    @user = users(:one)
    @user2 = users(:two)
    @restaurant = restaurants(:one)
  end

  teardown do
    Capybara.use_default_driver
  end

  

  test "add meeting members" do
    Capybara.current_driver = Capybara.javascript_driver
    show_one_meeting
    user_signin

    assert page.has_content?('First Lunch')

    click_link('Invite more')
    assert_equal current_path, 
     "#{meeting_path(@meeting)}/select_members"
    #assert page.has_content?('Bob')
    #assert page.has_content?('Annie')
    #check('Bob')
    fill_in 'temail', with: 'annie@annie.com'
    assert page.has_field?("temail", :with=>"annie@annie.com")
    click_button('Add member')

    #assert_equal page.evaluate_script('document.getElementById("addeduser").value'), 'annie@annie.com'
    ##assert_equal find("#addeduser").text, 'annie@annie.com'
    click_button('Send invite!')
    assert_equal current_path, meeting_path(@meeting)
    assert page.has_content?('Bob')
    assert page.has_content?('Annie')
  end

  test "edit restaurants" do
    Capybara.current_driver = Capybara.javascript_driver
    show_one_meeting
    user_signin

    click_link('Edit restaurant selection')
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
    assert page.has_content?('Canton Cooks')
  end

  # test "edit user" do
  #   Capybara.current_driver = Capybara.javascript_driver
  #   visit("/signin")
  #   user_signin
  #   visit("/users/#{@user.id}")
    
  #   assert_equal current_path, user_path(@user)
  #   assert page.has_content?('Bob')
  #   click_link('Edit')
  #   assert_equal current_path, edit_user_path(@user)
  #   fill_in 'user_username', with: 'Marty'
    
  #   click_button('Update User')
    
  #   assert_equal current_path, user_path(@user)
  #   assert page.has_content?('Marty')
  # end

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
    
    #visit("/meetings/#{@meeting.id}")
    visit(edit_meeting_path(@meeting))
    user_signin

    #page.find(:xpath, "//a[@href='/meetings/#{@meeting.id}/edit']").click

    assert_equal current_path, edit_meeting_path(@meeting)
    assert page.has_field?("title", :with=>"First Lunch")
    fill_in 'title', with: 'editing First Lunch'
    
    click_button('Update Meeting')

    assert_equal current_path, meeting_path(@meeting)
    assert page.has_content?('Editing First Lunch')
  end

  test "create meeting" do
    Capybara.current_driver = Capybara.javascript_driver
    visit("/meetings/new")
    user_signin

    fill_in 'title', with: 'Test Lunch'
    fill_in 'temail', with: 'annie@annie.com'
    assert page.has_field?("temail", :with=>"annie@annie.com")
    click_button('Add Member')
    assert_equal page.evaluate_script('document.getElementById("addeduser").value'), 'annie@annie.com'
    
    fill_in 'trest', with: 'canton cooks'
    assert page.has_field?('trest', :with=>'canton cooks')
    click_button('Add Restaurant')
    assert_equal page.evaluate_script('document.getElementById("addedrest").value'), 'canton cooks'
 
    click_button('Create Meeting')
    assert page.has_content?('Test Lunch')
    assert page.has_content?("Annie")
    assert page.has_content?("Canton Cooks")
    
    # uri = URI.parse(current_url)
    # newuri = "#{uri}?user=xyz@abc.com"
    # visit(uri)
    find("#tupa").click
    #page.all('#tupa')[0].click
    sleep(1)

    votes = page.all('.votenumber').map(&:text)
    assert_equal find(".votenumber").text, "1"

    votes = page.evaluate_script("$('td.votenumber').html()").to_i
    assert_equal votes, 1    

    find("#tdowna").click
    sleep(1)
    votes = page.all('table td.votenumber').map(&:text)
    assert_equal votes, ['0']
    assert_equal find(".votenumber").text, "0"

  end

  test "create user" do
    Capybara.current_driver = Capybara.javascript_driver
    visit("/users/new")

    fill_in 'user_username', with: 'Test User'
    fill_in 'user_email', with: 'testuser@test.com'
    fill_in 'user_password', with: 'lunchvoting'
    fill_in 'user_password_confirmation', with: 'lunchvoting'
    click_button("Create User")
    sleep 5

    assert page.has_content?("Test User")
    # assert page.has_content?("testuser@test.com")
    
    visit("/signout")
    visit("/signin")
    fill_in 'session_email', with: 'testuser@test.com'
    fill_in 'session_password', with: 'lunchvoting'
    click_button("Sign in")
    assert page.has_content?("Test User")
    user = User.where("email = 'testuser@test.com'").first
    assert_equal current_path, user_path(user)
  end

  test "create restaurant" do
    Capybara.current_driver = Capybara.javascript_driver
    visit("/restaurants/new")

    fill_in 'restaurant_name', with: 'A new restaurant'
    fill_in 'restaurant_address', with: 'new address road'
    fill_in 'restaurant_url', with: 'newrestaurant.com'
    click_button("Create Restaurant")

    assert page.has_content?("A New Restaurant")
    assert has_link?("A New Restaurant", :href=>"http://newrestaurant.com")
    assert page.has_xpath?("//a[@href='http://newrestaurant.com']")
  end

  test "edit restaurant" do
    Capybara.current_driver = Capybara.javascript_driver
    visit(restaurant_path(@restaurant))
    page.find(:xpath, "//a[@href='/restaurants/#{@restaurant.id}/edit']").click

    page.has_content?("Chipotle")
    fill_in 'restaurant_name', with: 'New name'
    fill_in 'restaurant_url', with: 'newrestaurant.com'
    click_button("Update Restaurant")

    assert page.has_content?("New Name")
    assert page.has_xpath?("//a[@href='http://newrestaurant.com']")

  end
end
