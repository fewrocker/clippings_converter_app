class Book
  attr_reader :name, :highlight_count

  def initialize(name)
    @name = name
    @highlight_count = 0
    @book_words = 0
  end

  def count_highlight
    @highlight_count += 1
  end

  def count_words(highlight)
    @book_words += count_words_in_string(highlight)
  end

  private

  def count_words_in_string(string)
    string.split(/\s+/).length
  end
end
