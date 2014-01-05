# mock native classes
`
IGHTMLDocument = function(){
  return {};
}
`
`
Log = function(message){
  console.log(message)
}

HTTPGet = function(url){
  return "fake " + url + " content"
}
`

require 'html_query'
require 'scraper_kit'
