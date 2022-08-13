require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get rubrique" do
    get articles_rubrique_url
    assert_response :success
  end

end
