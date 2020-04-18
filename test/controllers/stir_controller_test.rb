require 'test_helper'

class StirControllerTest < ActionDispatch::IntegrationTest
  test "should get stir" do
    get stir_stir_url
    assert_response :success
  end

  test "should get poll" do
    get stir_poll_url
    assert_response :success
  end

end
