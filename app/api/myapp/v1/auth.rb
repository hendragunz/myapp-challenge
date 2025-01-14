module Myapp
  class V1::Auth < Grape::API
    resources :auth do

      params do
        requires :user, type: Hash, documentation: { param_type: 'body' } do
          requires :email, type: String
          requires :password, type: String
        end
      end
      post do
        @user = User.authenticate!(params[:user][:email], params[:user][:password])
        error!("User with given email address is not found", 401) if @user.blank?

        @user.reset_authentication_token!

        # return this information
        {
          first_name:   @user.first_name,
          last_name:    @user.last_name,
          email:        @user.email,
          access_token: @user.authentication_token
        }
      end
    end
  end
end
