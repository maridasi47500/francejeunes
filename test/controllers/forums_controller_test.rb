require 'test_helper'

class ForumsControllerTest < ActionDispatch::IntegrationTest
  test "should get forumtype" do
    get forums_forumtype_url
    assert_response :success
  end

end
