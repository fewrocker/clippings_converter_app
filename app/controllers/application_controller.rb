class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def home

  end

  def return_books
    clippings = separate_content_into_clippings(params[:content])

    @books = create_highlights_from_clippings(clippings)

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

  def separate_content_into_clippings(content)
    clippings = content.gsub("\r\n","\n").split("==========").reject { |el| el == "\n" }

    clippings_array = []

    clippings.each do |clipping|
      clippings_array << Clipping.new(clipping)
    end

    clippings_array
  end

  def create_highlights_from_clippings(clippings)
    start_time = Time.now
    elapsed_delete_total = 0.to_f

    current_books = []

    clippings.each do |clipping|
      book_name = clipping.book_name

      book = current_books.find { |bk| bk.name == book_name }

      if book.nil?
        book = Book.create(name: book_name)
        current_books << book
      end

      highlight = Highlight.new
      highlight.content = clipping.highlight
      highlight.location_start = clipping.location_start.to_i
      highlight.location_end = clipping.location_end.to_i
      highlight.book = book
      highlight.save

      x = destroy_repeated_highlights(book, highlight)
      elapsed_delete_total += x if x
    end

    elapsed_end = Time.now
    elapsed_all = elapsed_end - start_time
    binding.pry

    current_books
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

  def destroy_repeated_highlights(book, highlight)
    start_time = Time.now

    # book.highlights.find_each do |h|
    #   book.highlights.where("#{h.location_start} BETWEEN location_start AND location_end").where("created_at < ?", h.created_at).destroy_all
    # end

    book.highlights.order('created_at desc').all.find_each do |h|
      next if h.id == highlight.id

      if highlight.content.include?(h.content) || h.content.include?(highlight.content)
        h.destroy
      end
    end

    # hls = book.highlights.order('content asc').all.to_a

    # hls.each do |hl|
    #   hl_index = hls.index(hl)
    #   hl2 = hls[hl_index + 1]

    #   if (hl.content.include?(hl2.content) || hl2.content.include?(hl.content)) && (hl2.created_at > hl.created_at)
    #     hl.destroy
    #     return if hl_index = hls.count - 1
    #   else
    #     return if hl_index = hls.count - 1
    #     next
    #   end
    # end

    return Time.now - start_time
  end

  def book_names(books)
    books.map(&:name)
  end

  def find_book(books, book)
    books.find { |b| b.name == book}
  end
end
