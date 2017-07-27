require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @otheruser = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end
  
  test "succesful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template('users/edit')
    name = "Michael Alo"
    email = "UpdateEmail@ga.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email.downcase, @user.email
  end
  
  test "should not edit when not logged in" do
    get edit_user_path(@user)
    assert_redirected_to login_url
    assert_not flash.empty?
  end
  
  test "should not update and redirect when not logged in" do
    
  
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "friendly forwarding after attempting to edit" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Michael Alo"
    email = "UpdateEmail@ga.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email.downcase, @user.email
  end
  
  test "should not be able to edit" do
    log_in_as(@otheruser)
    assert_not @otheruser.admin?
    patch user_path(@otheruser), params: {
                                    user: { password:"password",
                                            password_confirmation:"password",
                                            admin: true }
    }
    
    assert_not @otheruser.admin?
  end                                    
    
  test "should redirect destory when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when logged in as non-admin" do
    log_in_as(@otheruser)
    
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
end
