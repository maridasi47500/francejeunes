require 'test_helper'

class MeetingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get meetings_index_url
    assert_response :success
  end

end
