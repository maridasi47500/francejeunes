require 'test_helper'

class ParolesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get paroles_index_url
    assert_response :success
  end

end
