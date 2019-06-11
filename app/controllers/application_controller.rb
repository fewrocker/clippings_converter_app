class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def home

  end

  def return_books
    clippings = separate_content_into_clippings(params[:content])

    highlights = create_highlights_from_clippings(clippings)

    raise

    books = get_books_from_highlights(highlights)

    @books = books.map(&:name)

    render 'application/return_books.json'
  end

  # def return_highlights

  # end

  private

  def separate_content_into_clippings(content)
    clippings = content.split("==========").reject { |el| el === "\n" }

    clippings_array = []

    clippings.each do |clipping|
      clippings_array << Clipping.new(clipping)
    end

    clippings_array
  end

  def create_highlights_from_clippings(clippings)
    previous_books = Book.all
    current_books = []

    clippings.each do |clipping|
      book_name = clipping.book_name

      book = Book.find_by(name: book_name)

      if book.nil? || previous_books.include?(book)
        book = Book.create(name: book_name)
      end

      current_books << book

      highlight = Highlight.new
      highlight.content = clipping.highlight
      highlight.book = book
      highlight.save

      destroy_repeated_highlights(book)
    end

    current_books
  end

  def get_books_from_highlights(highlights)
    books = []

    highlights.each do |h|
      book = find_book(books, h.book)

      if book.nil?
        book = Book.new(h.book)
        books << book
      else
        book.count_highlight
        book.count_words(h.highlight)
      end
    end

    books.sort_by { |book| book.name }
  end

  def user_select_book(books)
    books.each do |b|
      pp "(#{books.index(b)}) #{b.name} (#{b.highlight_count} highlights)"
    end

    puts "Enter a book number to obtain highlights: "
    book_select = gets.chomp.to_i

    return books[book_select]
  end

  def write_file_with_highlights_for_books(highlights, book)
    open("books/#{book.name}_highlights.txt", 'w') { |f|
      f.puts "Highlights for #{book.name}"
      f.puts "\n"
      f.puts "\n"

      highlights.each do |h|
        next unless h.book == book.name

        f.puts h.highlight
        f.puts "\n"
      end
    }
  end

  def write_pdf_with_highlights_for_books(highlights, book)
    Prawn::Document.generate("books/#{book.name}_highlights.pdf") do
      font_size 16
      text "Highlights for #{book.name}"

      move_down 5

      font_size 12
      text "Total words: #{book.book_words}"

      move_down 20

      stroke_horizontal_rule
      text "\n"
      text "\n"

      highlights.each do |h|
        next unless h.book == book.name

        font("#{Prawn::DATADIR}/fonts/DejaVuSans.ttf") do
          text h.highlight, color: "282828", align: :justify
        end

        text "\n"
      end
    end
  end

  def destroy_repeated_highlights(book)
    last_highlight = book.highlights.last

    book.highlights.each do |h|
      next if h = last_highlight

      if last_highlight.content.include?(h.content) || h.content.include?(last_highlight.content)
        h.destroy
      end
    end
  end

  def book_names(books)
    books.map(&:name)
  end

  def find_book(books, book)
    books.find { |b| b.name == book}
  end
end
