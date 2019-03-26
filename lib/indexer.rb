# frozen_string_literal: true
class Indexer
  def create
    return 'index already exists' if index_exists?
    puts "creating War and Peace index..."
    CLIENT.indices.create(index: INDEX_NAME, **MAPPING)
  end

  def delete
    CLIENT.indices.delete(index: INDEX_NAME) if index_exists?
  end

  def index_exists?
    CLIENT.indices.exists?(index: INDEX_NAME)
  end
end
