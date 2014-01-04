class WalmartProductRecipe < ScraperKit::Recipe
  title "Walmart"
  on %r{http://www\.walmart\.com/search/search-ng\.do.+} do
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

  on_text "http://www\.walmart\.com/test.json" do
    JSON.parse(doc)
  end
end