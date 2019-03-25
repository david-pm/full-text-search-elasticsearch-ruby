require 'printer'

class Query
  attr_reader :term, :size, :printer
  def initialize(term, size = 10)
    return 'you need to create and populate your index' unless Writer.new.index_exists?
    @term    = term
    @size    = size
    @printer = Printer.new(term)
  end

  def find_all
    find_results(by_searchterm).each { |result| printer.hits(result) }
  end

  def find
    find_results(by_id).each { |result| printer.content(result) }
  end

  private

  def find_results(body)
    results(
      CLIENT.search(
        index: INDEX_NAME,
        size: size,
        body: body
      )
    )
  end

  def by_searchterm
    {
      query: { match: { contents: term } }
    }
  end

  def by_id
    {
      query: { term: { _id: term } }
    }
  end

  def results(raw_results)
    raw_results['hits']['hits'].map do |hit|
      {
        id: hit['_id'],
        book: hit['_source']['book'],
        chapter: hit['_source']['chapter'],
        contents: hit['_source']['contents']
      }
    end
  end
end
