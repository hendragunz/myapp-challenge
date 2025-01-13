require 'ostruct'

class KeywordsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_keyword, only: [:destroy]

  # GET - keywords_path
  #
  def index
    load_data
    @upload_keywords = OpenStruct.new()
  end

  # POST - keywords_path
  #
  def create
    parser        = KeywordParser.new(current_user, upload_keywords_params[:file])
    new_keywords  = parser.new_keywords

    if new_keywords.present?
      @keywords = current_user.keywords.insert_all(parser.new_keywords.map{|word| { name: word }})
      flash[:success] = "Successfully upload #{@keywords.length} keyword(s)"
      redirect_to action: :index
    else
      flash[:notice] = "New new keyword detected"
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
    @keywords = current_user.keywords.ascending
  end

  def upload_keywords_params
    params.require(:upload_keywords).permit(:file)
  end

  def find_keyword
    @keyword = current_user.keywords.find(params[:id])
  end

end
