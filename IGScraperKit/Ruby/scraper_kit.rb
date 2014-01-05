require 'json'
require 'scraper_kit/scraper'
require 'scraper_kit/recipe_registry'
require 'scraper_kit/recipe'

module Kernel
  def puts(message)
    `Log(message)`
  end
end