require 'config'
require 'parser'
require 'downloader'

class Writer
  attr_reader :parser

  def initialize
    @parser = Parser.new(Downloader.new.get_book).tap(&:call)
  end

  def create
    return 'index already exists' if index_exists?
    puts "creating War and Peace index..."
    CLIENT.indices.create(index: INDEX_NAME, **MAPPING)
  end

  def delete
    CLIENT.indices.delete(index: INDEX_NAME) if index_exists?
  end

  def upsert
    create unless index_exists?
    puts "downloading and parsing War and Peace..."

    parser.books.keys.each do |name|
      parser.books[name].keys.each do |chapter|
        CLIENT.index(index: INDEX_NAME, type: :document, body: body(name, chapter))
      end
    end

    clear
  end

  def index_exists?
    CLIENT.indices.exists?(index: INDEX_NAME)
  end

  private

  def body(name, chapter)
    puts "indexing #{name} - #{chapter}"

    {
      book: name,
      chapter: chapter,
      contents: parser.books[name][chapter].join(' ')
    }
  end

  def clear
    Gem.win_platform? ? (system "cls") : (system "clear")
    puts "Success! Check it out: localhost:9200"
  end
end
