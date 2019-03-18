require 'httparty'

class BookDownloader
  WAR_AND_PEACE = 'https://www.gutenberg.org/files/2600/2600-0.txt'

  def get_book
    HTTParty.get WAR_AND_PEACE
  end
end
