module ScraperKit
  class Scraper
    attr_reader :url, :recipe

    # recipe - the recipe object
    # url - regexp to the URL support by this scraper
    # block - a block to setup the scraper
    def initialize(recipe, url, &block)
      @recipe = recipe
      @url = url

      raise ArgumentError.new("Scraper requires a block") unless block_given?
      @scraper_block = block
    end

    def scrape(doc, url)
      @scraper_block.call(doc, url)
    end
  end
end