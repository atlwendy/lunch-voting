require 'test_helper'

class MeetingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @meeting = meetings(:one)
    @bob = users(:one)
  end

  test "can associate to user" do
    assert_difference("MeetingMembership.count", 1) do
      @meeting.users = [@bob]
    end
  end
end
