class Book < ApplicationRecord
  has_many :highlights, dependent: :destroy
end
