require 'test_helper'

class UltrazoneControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ultrazone_index_url
    assert_response :success
  end

end
