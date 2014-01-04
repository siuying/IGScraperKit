require '../Pods/IGHTMLQuery/IGHTMLQuery/Ruby/xml_node'
require '../Pods/IGHTMLQuery/IGHTMLQuery/Ruby/xml_node_set'
require '../Pods/IGHTMLQuery/IGHTMLQuery/Ruby/html_doc'
require '../IGScraperKit/Ruby/scraper_kit/recipe'
require '../IGScraperKit/Ruby/scraper_kit/recipe_registry'
require '../IGScraperKit/Ruby/scraper_kit/scraper'
require 'spec_helper'

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
end


# stub 

describe ScraperKit::Recipe do
  it "should set metadata with class method" do
    title = MyRecipe.metadata[:title]
    base_url = MyRecipe.metadata[:base_url]
    scrapers = MyRecipe.scrapers

    expect(title).to eq("SF")
    expect(scrapers.size).to eq(3)

    scraper = scrapers[0]
    expect(scraper.url).to eq("http://comic.sfacg.com/WeeklyUpdate/")
    expect(scraper.scrape(double(:node), double(:url))).to eq("a")

    scraper = scrapers[1]
    expect(scraper.url).to eq(%r{http://comic.sfacg.com/HTML/[^/]+/[^/]+/})
    expect(scraper.scrape(double(:node), double(:url))).to eq("b")
  end

  it "should registered to registry" do
    expect(ScraperKit::RecipeRegistry.instance.recipes).to include(MyRecipe)
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