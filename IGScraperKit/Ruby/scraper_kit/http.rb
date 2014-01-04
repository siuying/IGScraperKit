module ScraperKit
  module HTTP
    def self.get(url)
      %x{IGHTMLQueryGetHTTP(url)}
    end
  end
end