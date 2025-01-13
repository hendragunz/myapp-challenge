require 'csv'

class KeywordParser
  attr_accessor :keywords, :file, :current_user

  def initialize(current_user, file)
    @current_user = current_user
    @file         = file
    @keywords     = []

    # automatically parse the CSV data
    parse!
  end

  # Parse the CSV data
  # and return keywords as array
  #
  def parse!
    CSV.foreach(file, headers: true) do |row|
      @keywords.push(row['keyword']) if row['keyword'].present?
    end

    @keywords.uniq!
    @keywords
  end

  # to process return keywords that totally new
  #
  def new_keywords
    existing_keywords = current_user.keywords.all.map(&:name)
    @keywords - existing_keywords
  end
end
