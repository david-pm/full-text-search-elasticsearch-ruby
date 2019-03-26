# frozen_string_literal: true
require 'httparty'

class Downloader
  WAR_AND_PEACE = 'https://www.gutenberg.org/files/2600/2600-0.txt'

  def call
    HTTParty.get WAR_AND_PEACE
  end
end
