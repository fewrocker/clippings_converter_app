class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def home

  end

  def return_books
    start_time = Time.now

    @books = separate_clippings_into_books(params[:content])

    elapsed = Time.now - start_time

    binding.pry

    render 'application/return_books.json'
  end

  def return_highlights
    book = Book.find(params[:id])

    book_file_path = "public/books/#{book.id}_#{book.name}_highlights.docx"

    create_file_using_caracal(book, book_file_path)

    @book_download_url = book_file_path.gsub("public/", "")

    render 'application/return_highlights.json'
  end

  private

  def separate_clippings_into_books(content)
    clippings = content.gsub("\r\n","\n").split("==========").reject { |el| el == "\n" }

    current_books = []

    clippings.each do |clipping|
      clipping = Clipping.new(clipping)

      book_name = clipping.book_name
      book = current_books.find { |bk| bk.name == book_name }

      unless book
        book = Book.create(name: book_name)
        current_books << book
      end

      Highlight.create(
        content: clipping.highlight,
        book: book
      )
    end

    current_books.each do |book|
      destroy_repeated_highlights(book)
    end

    current_books
  end

  # def create_highlights_from_clippings(clippings, session_key)
  #   current_books = []

  #   clippings.each do |clipping|
  #     book_name = clipping.book_name
  #     book = current_books.find { |bk| bk.name == book_name }

  #     unless book
  #       book = Book.create(name: book_name, session_key: session_key)
  #       current_books << book
  #     end

  #     Highlight.create(
  #       content: clipping.highlight,
  #       book: book
  #     )
  #   end

  #   current_books.each do |book|
  #     destroy_repeated_highlights(book)
  #   end

  #   current_books
  # end

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

  def create_file_using_caracal(book, path)
    Caracal::Document.save path do |docx|
      docx.font do
        name "Helvetica"
      end

      docx.page_margins do
        left    800
        right   800
        top     1200
        bottom  1200
      end

      docx.style do
        id "document_title"
        name "Document title"
        color "000000"
        size 25
        bold true
        align :left
      end

      docx.style do
        id "document_subtitle"
        name "Document subtitle"
        color "191919"
        size 22
        bold false
        align :left
      end

      docx.style do
        id "highlight"
        name "Highlight"
        color "191919"
        size 20
        bold false
        align :both
      end

      docx.p "Highlights for #{book.name}", style: 'document_title'
      docx.p "#{book.highlights.count} highlights for this book", style: 'document_subtitle'
      docx.p
      docx.hr
      docx.p

      book.highlights.all.order('id asc').each do |hl|
        docx.p hl.content, style: 'highlight'
        docx.p
      end
    end
  end

  def destroy_repeated_highlights(book)
    hls = book.highlights.order('content asc').all.to_a
    hl_group = []
    previous_content = "abcdefg"

    hls.each do |hl|
      content = hl.content.dup
      if content.include?(previous_content) || previous_content.include?(content)
        hl_group << hl
      else
        hl_group.sort_by(&:created_at)[0..-2].each(&:destroy)
        hl_group = [hl]
      end

      previous_content = content
    end
  end

  def book_names(books)
    books.map(&:name)
  end

  def find_book(books, book)
    books.find { |b| b.name == book}
  end
end
