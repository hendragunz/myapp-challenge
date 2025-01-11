module Myapp
  class V1::API < Grape::API
    version 'v1'

    desc 'Return a test API Response'
    get :ping do
      { hello: :world }
    end
  end
end
