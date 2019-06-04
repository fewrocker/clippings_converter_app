class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def home

  end

  def return_books
    pp "Reached here"

    @books = [1,2,3]

    render 'application/return_books.json'
  end

  def return_highlights

  end
end
