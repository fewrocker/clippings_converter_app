class Book < ApplicationRecord
  attr_reader :name, :highlight_count

  def initialize(name)
    @name = name
    @highlight_count = 0
  end

  def count_highlight
    @highlight_count += 1
  end
end
