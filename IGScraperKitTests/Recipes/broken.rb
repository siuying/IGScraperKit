class GoogleRecipe < ScraperKit::Recipe
    title "Google Search"
    on %r{https://www\.google\.com/search\?q=.+} do