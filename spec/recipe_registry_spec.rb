require '../IGScraperKit/Ruby/scraper_kit/recipe'
require '../IGScraperKit/Ruby/scraper_kit/recipe_registry'
require '../IGScraperKit/Ruby/scraper_kit/scraper'

class RecipeRegistryRecipe < ScraperKit::Recipe
  title "RecipeRegistryRecipe"

  on %r{http://google.com/.+} do |node, url|
    "a"
  end
end

describe ScraperKit::RecipeRegistry do
  describe "#scraper_for_url" do
    it "should return nil for unsupported url" do
      scraper = ScraperKit::RecipeRegistry.instance.scraper_for_url("http://www.yahoo.com")
      expect(scraper).to be_nil
    end

    it "should return the recipe for supported url" do
      scraper = ScraperKit::RecipeRegistry.instance.scraper_for_url("http://google.com/123")
      expect(scraper).to eq(RecipeRegistryRecipe.scrapers.first)
    end
  end
end