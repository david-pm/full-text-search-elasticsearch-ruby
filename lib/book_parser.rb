class BookParser
  EOF_REGEX     = /^End of the Project Gutenberg EBook of War and Peace, by Leo Tolstoy/
  BOOK_REGEX    = /^BOOK\s\w*:\s.*|^\w*\sEPILOGUE:?\s?.*/
  CHAPTER_REGEX = /^CHAPTER\s\w*/

  attr_reader :books, :lines
  def initialize(raw_lines = nil)
    @books = {}
    @lines = sanitize_lines(raw_lines)
    @chapter_title = @book_title = nil
  end

  def call
    relevant_lines.each do |line|
      # create the book
      if (book_match = line.match BOOK_REGEX)
        @book_title = book_match[0]
        books[@book_title] = {}
        next
      end
      # add the chapter to the current book
      if (chapter_match = line.match CHAPTER_REGEX)
        @chapter_title = chapter_match[0]
        books[@book_title][@chapter_title] = []
        next
      end
      # add the paragraphs to the current book & chapter
      books[@book_title][@chapter_title] << line
    end
  end

  private

  def sanitize_lines(raw_lines)
    raw_lines.split("\r\n").map { |l| l unless l.empty? }.compact
  end

  def relevant_lines
    start_of_book = lines.find_index { |line| line =~ BOOK_REGEX }
    end_of_book   = lines.find_index { |line| line =~ EOF_REGEX }
    lines[start_of_book...end_of_book]
  end
end
