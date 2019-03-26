# frozen_string_literal: true
require 'config'
require 'parser'
require 'indexer'
require 'downloader'

class Writer
  attr_reader :parser, :indexer

  def initialize
    @indexer = Indexer.new
    @parser  = Parser.new(Downloader.new.call).tap(&:call)
  end

  def upsert
    indexer.create unless indexer.index_exists?
    puts "downloading and parsing War and Peace..."

    parser.books.keys.each do |name|
      parser.books[name].keys.each do |chapter|
        CLIENT.index(index: INDEX_NAME, type: :document, body: body(name, chapter))
      end
    end

    clear
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
