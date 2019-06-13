json.books @books do |book|
  json.id book.id
  json.name book.name
  json.highlight_count book.highlights.count
end
