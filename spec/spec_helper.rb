# redefine HTTP.get for test
module ScraperKit
  module HTTP
    def self.get(url)
      "fake #{url} content"
    end
  end
end

# mock native classes
`
IGHTMLDocument = function(){
  return {};
}
`
