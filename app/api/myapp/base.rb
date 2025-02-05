module Myapp
  class Base < Grape::API
    format :json
    prefix :api

    mount Myapp::V1::API => '/'

    helpers do
      def current_user
        @current_user ||= User.authorize!(env)
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end
  end
end
