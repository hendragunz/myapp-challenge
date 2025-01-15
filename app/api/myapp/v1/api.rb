module Myapp
  class V1::API < Grape::API
    version 'v1'

    helpers do
      def warden
        env['warden']
      end

      def authenticated
        return true if warden.authenticated?
        headers['access-token'] && @user = User.find_by_authentication_token(headers['access-token'])
      end

      def current_user
        warden.user || @user
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      error!("Data not found", 404)
    end

    desc 'Return a test API Response'
    get :ping do
      { hello: :world }
    end

    mount Myapp::V1::Auth
    mount Myapp::V1::Keywords
  end
end
