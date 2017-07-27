require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "      "
    assert_not @user.valid?
  end 
  
  
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a"*251 + "@example.com"
    assert_not @user.valid?
  end
  
  
  test "email validation should accept valid emails" do
    valid_addresses = %w[user@example.com USER@foo.com Test@jp.woo adf+fasd@gd.cm]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
    
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
     end
  end  
  
  test "email address must be uniuq" do
    duplicate_add = @user.dup
    duplicate_add.email = @user.email.upcase
    @user.save
    assert_not duplicate_add.valid?
  end
    
  test "password should not be blank" do
    @user.password = "   "
    assert_not @user.valid?
  end
  
  test "password should be of certain length" do
    @user.password = "a"
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

end
