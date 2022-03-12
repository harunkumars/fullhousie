require "test_helper"

class LotteriesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get lotteries_show_url
    assert_response :success
  end
end
