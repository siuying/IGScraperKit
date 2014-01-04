require "rubygems"
require "bundler"
Bundler.require
require 'open3'

require 'opal/rspec/rake_task'
Opal::RSpec::RakeTask.new(:'spec:js')

desc "Run Objective-C specs"
task :'spec:objc' do
  system "xcodebuild -workspace IGScraperKit.xcworkspace -scheme IGScraperKit -destination=build -configuration Debug -sdk iphonesimulator7.0 ONLY_ACTIVE_ARCH=YES build test | xcpretty -c"
end

desc "Run Objective-C and opal specs"
task :spec => [:'spec:js', :'spec:objc']

desc "Build JavaScripts from Ruby"
task :build do  
  env = Opal::Environment.new
  env.append_path "IGScraperKit/Ruby"

  File.open("IGScraperKit/JavaScript/scraper_kit.js", "w+") do |out|
    out << env["scraper_kit"].to_s
  end
end

task :default => :build