require 'test_helper'

class MeetingTest < ActiveSupport::TestCase

  setup do
    @meeting = meetings(:one)
    @bob = users(:one)
    @annie = users(:two)
    @first = restaurants(:one)
    @second = restaurants(:two)
  end

  test "can associate to user" do
    assert_difference("MeetingMembership.count", 1) do
      @meeting.users = [@annie, @bob]
    end
  end

  test "can associate to restaurant" do
    assert_difference("MeetingRestaurantSelection.count", 1) do
      @meeting.restaurants = [@first, @second]
    end
  end
end
