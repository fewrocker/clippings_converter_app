class Highlight < ApplicationRecord
  belongs_to :book



  def book
    email = extract_first_email_from_string(@book_line)

    @book_line.split(email).first
  end

  def highlight
    @highlight_line
  end

  private

  def extract_first_email_from_string(txt)
    reg = /\s*\([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
    txt.scan(reg).uniq.first
  end

end
