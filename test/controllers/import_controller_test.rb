require 'test_helper'

class ImportControllerTest < ActionController::TestCase
  test "should get getdata" do
    get :getdata
    assert_response :success
  end

end
