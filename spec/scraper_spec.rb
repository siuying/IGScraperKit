require '../IGScraperKit/Ruby/scraper_kit/recipe'
require '../IGScraperKit/Ruby/scraper_kit/recipe_registry'
require '../IGScraperKit/Ruby/scraper_kit/scraper'

describe ScraperKit::Scraper do
  it "should create a builder with specific properties" do
    link_builder = ScraperKit::Scraper.new("recipe", "http://.+") do |doc, url|
      "block result"
    end
    expect(link_builder.recipe).to eq("recipe")
    expect(link_builder.url).to eq("http://.+")
    expect(link_builder.scrape(double(:doc), double(:url))).to eq("block result")
  end
end