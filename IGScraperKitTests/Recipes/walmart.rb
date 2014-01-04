class WalmartProductRecipe < ScraperKit::Recipe
  title "Walmart"
  on %r{http://www\.walmart\.com/search/search-ng\.do.+} do |doc, url|
    title = doc.xpath('//title').text
    items = doc.xpath("//*[contains(concat(' ', normalize-space(@class), ' '), ' item ')]").collect { |item|
      {
        :title => item.xpath(".//*[contains(concat(' ', normalize-space(@class), ' '), ' prodLink ')]").text,
        :price => item.xpath(".//*[contains(concat(' ', normalize-space(@class), ' '), ' camelPrice ')]").text,
        :href => item.xpath(".//*[contains(concat(' ', normalize-space(@class), ' '), ' prodLink ')]/@href").text
      }
    }

    {
      :title => title,
      :items => items
    }
  end
end