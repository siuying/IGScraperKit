Pod::Spec.new do |s|
  s.name         = "IGScraperKit"
  s.version      = "0.1.0"
  s.summary      = "Create dynamic web scraper in Objective-C, using block or JavaScript."

  s.description  = <<-DESC
Create dynamic web scraper in Objective-C, using block or JavaScript.
DESC

  s.homepage     = "https://github.com/siuying/IGScraperKit"

  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }

  s.author       = { "Francis Chong" => "francis@ignition.hk" }

  s.source       = { :git => "https://github.com/siuying/IGScraperKit.git", :tag => s.version.to_s }

  s.default_subspec = 'Core'

  s.requires_arc = true

  s.library   = 'xml2'

  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

  s.subspec "Core" do |sp|
    sp.ios.deployment_target = '6.0'
    sp.osx.deployment_target = '10.8'
    sp.dependency 'IGHTMLQuery'
    sp.source_files  = 'IGScraperKit/Classes/**/*.{h,m}'
  end

  # Include IGHTMLQuery/JavaScript to enable JavaScriptCore support.
  s.subspec "JavaScript" do |sp|
    sp.ios.deployment_target = '7.0'
    sp.osx.deployment_target = '10.8'
    sp.prefix_header_contents = '#define IGSCRAPER_JAVASCRIPT_ADDITIONS'
    sp.dependency 'IGHTMLQuery/JavaScript'
    sp.source_files  = 'IGScraperKit/Classes/**/*.{h,m}'
  end
end
