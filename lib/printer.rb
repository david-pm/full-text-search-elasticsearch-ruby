# frozen_string_literal: true
class Printer
  attr_reader :term
  def initialize(term)
    @term = term
  end

  def hits(result)
    header(result)
    histogram(result).each do |token, count|
      puts "#{token.ljust(22)} - #{count}"
    end
    puts
  end

  def content(result)
    header(result)
    puts
    puts "#{result[:contents]}"
    puts
  end

  def basic(result)
    header(result)
  end

  private

  def header(result)
    puts
    puts "ID".ljust(23) + "- #{result[:id]}"
    puts "#{result[:book].ljust(22)} - #{result[:chapter]}"
  end

  def histogram(result)
    histogram_keys.each_with_object({}) do |key, hash|
      hash[key] = result[:contents].scan(/#{key}/i).count
    end
  end

  def histogram_keys
    [term] + term.split
  end
end
