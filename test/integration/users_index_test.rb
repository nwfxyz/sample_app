require 'test_helper'


class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "delete user success" do
    log_in_as(@admin)
  
  
    get users_url
    assert_template "users/index"
    assert_select "div.pagination"
    User.paginate(page:1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
    assert_redirected_to users_url
  end
  

end
