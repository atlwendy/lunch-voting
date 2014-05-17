require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "create a new user" do
  	newuser = User.new(email: 'x@abc.com', password: 'thisisatest')
  	newuser.save
  	assert_equal newuser.errors.messages[:email][0], "is invalid"
  	newuser.password = 'hello'
  	newuser.save
  	assert_equal newuser.errors.messages[:password][0], "is too short (minimum is 6 characters)" 
  end
end
