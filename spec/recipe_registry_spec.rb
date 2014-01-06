require 'spec_helper'
require 'recipes/my_recipe'

describe ScraperKit::RecipeRegistry do
  describe "#recipes" do
    it "should loaded recipes" do
      recipes = ScraperKit::RecipeRegistry.instance.recipes
      expect(recipes.size).to eq(1)
    end
  end

  describe "#recipe_for_url" do
    it "should return nil for unsupported url" do
      recipe = ScraperKit::RecipeRegistry.instance.recipe_for_url("http://www.yahoo.com")
      expect(recipe).to be_nil
    end

    it "should return the recipe for supported url" do
      recipe = ScraperKit::RecipeRegistry.instance.recipe_for_url("http://comic.sfacg.com/WeeklyUpdate/")
      expect(recipe).to_not be_nil
      expect(recipe).to eq(MyRecipe)
    end
  end

  describe "#scraper_for_url" do
    it "should return nil for unsupported url" do
      scraper = ScraperKit::RecipeRegistry.instance.scraper_for_url("http://www.yahoo.com")
      expect(scraper).to be_nil
    end

    it "should return the recipe for supported url" do
      scraper = ScraperKit::RecipeRegistry.instance.scraper_for_url("http://comic.sfacg.com/WeeklyUpdate/")
      expect(scraper).to_not be_nil
      expect(scraper).to eq(MyRecipe.scrapers.first)
    end
  end
end