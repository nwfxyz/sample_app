require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  
  test "logg in to see all" do
    get users_path
    assert_redirected_to login_path
  end
  
end
