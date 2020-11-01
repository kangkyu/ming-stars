require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "gets new" do
    get new_account_path
    assert_response :success
  end
end
