# frozen_string_literal: true
INDEX_NAME = 'war_and_peace'
CLIENT = Elasticsearch::Client.new(host: 'localhost', port: '9200')
MAPPING = {
  body: {
    mappings: {
      document: {
        properties: {
          book: { type: :text },
          chapter: { type: :text },
          contents: { type: :text, analyzer: :english }
        }
      }
    }
  }
}.freeze
