class GoogleRecipe < ScraperKit::Recipe
  title "Google Search"
  on %r{https://www\.google\.com/search\?q=.+} do |doc, url|
    doc.xpath('//h3/a').collect {|node| node.text }
  end
end