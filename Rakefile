require "rubygems"
require "bundler"
Bundler.require

require 'opal/rspec/rake_task'
Opal::RSpec::RakeTask.new(:spec)

desc "Build JavaScripts from Ruby"
task :build do  
  env = Opal::Environment.new
  env.append_path "IGScraperKit/Ruby"

  File.open("IGScraperKit/JavaScript/scraper_kit.js", "w+") do |out|
    out << env["scraper_kit"].to_s
  end
end

task :default => :build