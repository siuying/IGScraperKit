require 'scraper_kit/recipe'

class MyRecipe < ScraperKit::Recipe
  title "SF"

  on "http://comic.sfacg.com/WeeklyUpdate/" do |node, url|
    "a"
  end

  on %r{http://comic.sfacg.com/HTML/[^/]+/[^/]+/} do |node, url|
    "b"
  end

  on %r{http://comic.sfacg.com/redirect} do |node, url|
    get "http://comic.sfacg.com/WeeklyUpdate/"
  end

  on_text %r{http://comic.sfacg.com/.+/.+\.js$} do |text, url|
    "c"
  end
end
