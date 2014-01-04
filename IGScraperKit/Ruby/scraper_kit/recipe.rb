module ScraperKit
  class Recipe
    module ClassMethods
      def metadata
        @metadata ||= {}
      end

      def scrapers
        @scrapers ||= []
      end

      def title(title)
        metadata[:title] = title
      end

      def on(url, &block)
        scrapers << Scraper.new(self, url, &block)
      end

      def on_text(url, &block)
        scrapers << Scraper.new(self, url, :text, &block)
      end

      def inherited(subclass)
        RecipeRegistry.register(subclass)
      end

      # Get first scraper defined to scrape the supplied URL
      # return a scraper if one is defined. return nil otherwise.
      def scraper_for_url(url)
        scrapers.detect {|scraper| scraper.url.is_a?(Regexp) ? (url =~ scraper.url) : (url == scraper.url) }
      end
    end
    extend ClassMethods
  end
end