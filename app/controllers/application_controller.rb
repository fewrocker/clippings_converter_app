class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def home

  end

  def return_books
    separated_clippings = separate_content_into_clippings(params[:content])

    highlights = create_highlights_from_clippings(separated_clippings)

    books = get_books_from_highlights(highlights)

    @books = books.map(&:name)

    render 'application/return_books.json'
  end

  # def return_highlights

  # end

  private

  def separate_content_into_clippings(content)
    content.split("==========").reject { |el| el === "\n" }
  end

  def create_highlights_from_clippings(clippings)
    highlights = []

    clippings.each do |clipping|
      highlights << Highlight.new(clipping)
      highlights = delete_repeated_highlights(highlights)
    end

    highlights
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

  def delete_repeated_highlights(highlights)
    last_highlight = highlights.last

    return highlights.reject do |h|
      h != highlights.last && (last_highlight.highlight.include?(h.highlight) || h.highlight.include?(last_highlight.highlight))
    end
  end

  def book_names(books)
    books.map(&:name)
  end

  def find_book(books, book)
    books.find { |b| b.name == book}
  end
end
