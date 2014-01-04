module ScraperKit
  class ScraperScope
    attr_reader :doc, :url, :recipe

    def initialize(recipe, doc, url)
      @recipe = recipe
      @doc = doc
      @url = url
    end

    def get(url)
      html = HTTP.get(url)
      if html
        doc = HTMLDoc.new(html)
        if doc
          scraper = recipe.scraper_for_url(url)
          if scraper
            scraper.scrape(doc, url)
          else
            {:error => "scraper not found for url: #{url}, recipe: #{recipe}"}
          end
        else
          {:error => "failed processing html"}
        end
      else
        {:error => "failed fetching html from url: #{url}"}
      end
    end
  end

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
      ScraperScope.new(recipe, doc, url).instance_eval(&@scraper_block)
    end

  end
end