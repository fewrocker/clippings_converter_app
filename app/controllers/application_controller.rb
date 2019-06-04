class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def home

  end

  def return_books
    pp "Reached here"
    pp params
    @books = [1,2,3]
  end

  def return_highlights

  end
end
