module Myapp
  class V1::Keywords < Grape::API
    before do
      error!("401 Unauthorized", 401) unless authenticated
    end

    helpers do
      def upload_keywords_params
        declared(params)[:keyword]
      end
    end

    resources :keywords do
      desc "Return all keywords"
      get do
        @keywords = current_user.keywords.newest
        present @keywords, with: Entities::KeywordEntity
      end

      desc "To create keywords from uploaded file"
      params do
        requires :keyword, type: Hash do
          requires :file, type: File, allow_blank: false
        end
      end
      post do
        begin
          error!("Uploaded file must by CSV", 400) unless upload_keywords_params[:file][:type] == 'text/csv'
          parser = KeywordParser.new(current_user, upload_keywords_params[:file][:tempfile])

          error!("Uploaded file must have keywords less or equal than 100 rows", 400) if parser.keywords.length > 100
          error!("Uploaded file must have at least 1 row", 400) if parser.keywords.blank?

          new_keywords = parser.new_keywords

          if new_keywords.present?
            @keywords = new_keywords.map{|rec| current_user.keywords.create(name: rec)}
            present @keywords, with: Entities::KeywordEntity
          else
            error!("Unable to see new keywords", 422)
          end

        rescue CSV::InvalidEncodingError => e
          error!("Bad CSV file, please double check again", 400)
        end
      end



      params do
        requires :id, type: Integer, desc: 'Keyword ID.'
      end
      route_param :id do
        before do
          @keyword = current_user.keywords.find(params[:id])
        end

        desc "Return detail of keyword result"
        get do
          present @keyword, with: Entities::KeywordEntity
        end

        desc "To remove keyword"
        delete do
          @keyword.destroy
          present @keyword, with: Entities::KeywordEntity
        end
      end
    end
  end
end
