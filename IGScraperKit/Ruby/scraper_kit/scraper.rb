module ScraperKit
  class ScraperScope
    attr_reader :recipe, :scraper_type, :doc, :url

    def initialize(recipe, type, doc, url)
      @recipe = recipe
      @scraper_type = type
      @doc = doc
      @url = url
    end

    # Get the target URL, and send it to another scraper
    #
    # url - URL to be get
    #
    # @return return the scraped result if succeed. return a hash with one key :error if failed.
    def get(get_url)
      html = IGHTMLQuery::HTTP.get(get_url)
      if html
        scraper = recipe.scraper_for_url(get_url)
        if scraper
          get_doc = (scraper.type == :text) ? html : HTMLDoc.new(html)
          if get_doc
            scraper.scrape(get_doc, get_url)
          else
            {:error => "cannot process document: \n#{html}"}
          end
        else
          {:error => "scraper not found for url: #{get_url}, recipe: #{recipe}"}
        end
      else
        {:error => "failed fetching html from url: #{get_url}"}
      end
    end
  end

  class Scraper
    attr_reader :url, :recipe, :type

    # recipe - the recipe object
    # url - regexp to the URL support by this scraper
    # type - scraper type, it is either :html or :plain
    #    :text - document as String is passed to the scraper block
    #    :html - document converted to XMLNode is passed to scraper block
    # block - a block to setup the scraper
    def initialize(recipe, url, type=:html, &block)
      @recipe = recipe
      @url = url
      @type = type

      raise ArgumentError.new("Scraper requires a block") unless block_given?
      @scraper_block = block
    end

    def scrape(the_doc, the_url)
      if the_doc.is_a?(XMLNode)
        raise "Attempt to scrape HTML with text parser" if type == :text
        ScraperScope.new(recipe, type, the_doc, url).instance_eval(&@scraper_block)
      else
        doc = (type == :text) ? the_doc : HTMLDoc.new(the_doc)
        ScraperScope.new(recipe, type, doc, the_url).instance_eval(&@scraper_block)
      end
    end

    def to_s
      "<Scraper##{recipe.name} url=#{url}>"
    end
  end
end