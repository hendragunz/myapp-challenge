module Entities
  class KeywordEntity < Grape::Entity
    root 'keywords', 'keyword'

    expose :id, documentation: {
      type: "Integer",
      desc: "The keyword's unique identifier",
      example: 42
    }

    expose :name, documentation: {
      type: 'String',
      desc: "Keyword name",
      example: 'Best car in Thailand'
    }

    expose :total_adwords, documentation: {
      type: 'Integer',
      desc: "Total AdWords found",
      example: '10'
    }

    expose :total_links, documentation: {
      type: 'Integer',
      desc: "Total Links found",
      example: '10'
    }

    expose :total_search_results, documentation: {
      type: 'String',
      desc: "Total search results",
      example: 'Sekitar 13.800.000 hasil (0,43 detik)'
    }

    expose :created_at, documentation: {
      type: "String",
      format: "date-time",
      desc: "When the keyword created",
      example: Time.now.utc.iso8601(3)
    }

    expose :processed_at, documentation: {
      type: "String",
      format: "date-time",
      desc: "When the web scrap processed",
      example: Time.now.utc.iso8601(3)
    }
  end
end
