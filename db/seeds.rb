Highlight.all.each do |h|
  h.destroy
  pp "Highlight destroyed"
end

Book.all.each do |b|
  b.destroy
  pp "Book destroyed"
end
