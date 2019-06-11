Rails.application.routes.draw do
  root to: 'application#home'

  post 'return_books', to: 'application#return_books', as: 'return_books'
  post 'return_highlights', to: 'application#return_highlights', as: 'return_highlights'
end
