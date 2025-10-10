class Services::SearchService
  SEARCH_AREA = %w[Questions Answers Comments Users].freeze

  def self.call(query, area = nil)
    model_klass = model_klass(area)
    escaped_query = escaped_query(query)

    model_klass.search(escaped_query)
  end

  private

  def self.model_klass(area)
    return ThinkingSphinx unless SEARCH_AREA.include?(area)

    area.singularize.classify.constantize
  end

  def self.escaped_query(query)
    ThinkingSphinx::Query.escape(query)
  end
end
