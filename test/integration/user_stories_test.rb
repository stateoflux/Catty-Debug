require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  setup do
    @wayne = Factory(:user)
    @mikki = build_mikki
  end

  test "log in create debug session and log out" do
    wayne = registered_user
    mikki = registered_user
    wayne.logs_in("wmontagu@cisco.com")
    mikki.logs_in("mikki@cisco.com")
    wayne.creates_debug_session
    wayne.creates_debug_session
    wayne.logs_out
    mikki.logs_out
  end

  def registered_user
    open_session do |user|
      def user.logs_in(email)
        get login_path
        assert_response :success
        assert_template 'new'

        post session_path, :email => email
        assert_response :redirect
        assert_redirected_to assigns(:user) 

        follow_redirect!

        assert_response :success
        assert_template 'show'
        assert session[:user_id]
      end

      def user.logs_out
        get logout_path
        assert_response :redirect
        assert_redirected_to root_path
        assert_nil session[:user_id]

        follow_redirect!
        
        assert_template 'new'
      end

      def user.creates_debug_session
        assembly = Factory(:assembly)
        get new_r2d2_debug_path
        assert_response :success
        assert_template 'new'

        post r2d2_debugs_path, :r2d2_debug => {
          :serial_number => "SAD911222UX",
          :assembly_id => assembly.to_param
        },
        :test_result => test_result_dump
        assert_template 'show_results'
        assert_not_nil assigns(:r2d2_debug)
        assert_not_nil assigns(:just_created)
        assert_not_nil session[:debug_id] 
      end
    end
  end
end
