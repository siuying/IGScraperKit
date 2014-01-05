require 'spec_helper'
require 'recipes/my_recipe'

describe ScraperKit::Recipe do
  describe "subclassed" do
    it "should set metadata with class method" do
      title = MyRecipe.metadata[:title]
      scrapers = MyRecipe.scrapers

      expect(title).to eq("SF")
      expect(scrapers.size).to eq(4)

      scraper = scrapers[0]
      expect(scraper.type).to eq(:html)
      expect(scraper.url).to eq("http://comic.sfacg.com/WeeklyUpdate/")
      expect(scraper.scrape(double(:node), double(:url))).to eq("a")

      scraper = scrapers[1]
      expect(scraper.type).to eq(:html)
      expect(scraper.url).to eq(%r{http://comic.sfacg.com/HTML/[^/]+/[^/]+/})
      expect(scraper.scrape(double(:node), double(:url))).to eq("b")

      scraper = scrapers[3]
      expect(scraper.type).to eq(:text)
      expect(scraper.url).to eq(%r{http://comic.sfacg.com/.+/.+\.js$})
      expect(scraper.scrape(double(:html), double(:url))).to eq("c")
    end

    it "should registered to registry" do
      expect(ScraperKit::RecipeRegistry.instance.recipes).to include(MyRecipe)
    end
  end

  describe "#scraper_for_url" do
    it "should find the scraper defined by string url" do
      scraper = MyRecipe.scraper_for_url("http://comic.sfacg.com/WeeklyUpdate/")
      expect(scraper.scrape(double(:node), double(:url))).to eq("a")
    end

    it "should find the scraper defined by regexp url" do
      scraper = MyRecipe.scraper_for_url("http://comic.sfacg.com/HTML/123/456/")
      expect(scraper.scrape(double(:node), double(:url))).to eq("b")
    end

    it "should not find the non-exist URL" do
      scraper = MyRecipe.scraper_for_url("http://maps.google.com")
      expect(scraper).to be_nil
    end
  end

  describe "#get" do
    it "should get the URL and processed with appropriate scraper" do
      scraper = MyRecipe.scraper_for_url("http://comic.sfacg.com/redirect")

      # should call HTTP.get, 
      # get the next url as specified in scraper, then process it
      expect(scraper.scrape(double(:node), "http://comic.sfacg.com/redirect")).to eq("a")
    end
  end
end