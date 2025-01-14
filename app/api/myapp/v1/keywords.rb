module Myapp
  class V1::Keywords < Grape::API
    before do
      error!("401 Unauthorized", 401) unless authenticated
    end

    resources :keywords do
      desc "Return all keywords"
      get do
        @keywords = current_user.keywords.newest
        present @keywords, with: Entities::KeywordEntity
      end


      desc "Return detail of keyword result"
      params do
        requires :id, type: Integer, desc: 'Keyword ID.'
      end
      route_param :id do
        get do
          @keyword = current_user.keywords.find(params[:id])
          present @keyword, with: Entities::KeywordEntity
        end
      end
    end
  end
end
