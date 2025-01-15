require 'ostruct'

class KeywordsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  before_action :authenticate_user!
  before_action :find_keyword, only: [:destroy, :show]

  # GET - keywords_path
  #
  def index
    load_data
    @search = OpenStruct.new(search_params)
  end

  def show; end

  # POST - keywords_path
  #
  def create
    begin
      return redirect_to({action: :index}, flash: {error: 'Uploaded CSV file must be exists'}) if upload_keywords_params[:file].blank?
      parser = KeywordParser.new(current_user, upload_keywords_params[:file])

      if parser.keywords.length > 100
        flash[:error] = "Please upload with maximum 100 rows per file"
        return redirect_to action: :index
      elsif parser.keywords.length == 0
        flash[:error] = "Please upload minimum 1 keyword in file"
        return redirect_to action: :index
      end

      new_keywords  = parser.new_keywords

      if new_keywords.present?
        @keywords = new_keywords.map{|rec| current_user.keywords.create(name: rec)}
        flash[:success] = "Successfully upload #{@keywords.length} keyword(s)"
        redirect_to action: :index
      else
        flash[:notice] = "New new keyword detected"
        redirect_to action: :index
      end

    rescue CSV::InvalidEncodingError => e
      flash[:error] = "File type must be CSV"
      redirect_to action: :index
    end
  end

  # DELETE - keyword_path(id)
  #
  def destroy
    @keyword.destroy
    flash[:success] = "Successfully destroy keyword: #{@keyword.name}"
    redirect_to action: :index
  end

  private

  def load_data
    @keywords = current_user.keywords.quick_search(search_params[:terms])
  end

  def search_params
    params.fetch(:search, {}).permit(:terms)
  end

  def upload_keywords_params
    params.require(:upload_keywords).permit(:file)
  end

  def find_keyword
    @keyword = current_user.keywords.find(params[:id])
  end

  def record_not_found
    flash[:error] = "The page you're looking for is not found"
    redirect_to action: :index
  end
end
