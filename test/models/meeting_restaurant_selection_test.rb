require 'test_helper'

class MeetingRestaurantSelectionTest < ActiveSupport::TestCase
  setup do
    @restaurant = restaurants(:one)
    @meeting = meetings(:one)
  end 

  test "meeting restaurant association" do
    @meeting.restaurants = [@restaurant]
    assert_equal MeetingRestaurantSelection.count, 1
  end 
end
