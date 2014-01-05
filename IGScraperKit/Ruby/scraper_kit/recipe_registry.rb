require 'singleton'

module ScraperKit
  class RecipeRegistry
    include Singleton

    def initialize
      @recipes = []
    end

    def recipes
      @recipes
    end

    # get first scraper from all recipes that can scrape the supplied URL
    def scraper_for_url(url)
      scraper = nil
      recipes.find {|recipe| scraper = recipe.scraper_for_url(url) }
      scraper
    end

    def register(scraper_class)
      recipes << scraper_class
    end
  end
end