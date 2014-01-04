# IGScraperKit

Create dynamic web scraper in Objective-C or Ruby.

## Usage

Create a scraper:

```
#import "IGScraperKit.h"
IGScraper* scraper = [IGScraper scraperWithBlock:^id(IGXMLNode* node) {
                return [[[node queryWithXPath:@"//p"] firstObject] text];
            }];
```

Then scrape HTML with scraper:

```
[scraper scrape:@"<html><p>Hello World</p></html>" url:nil];
```

If you want something more dynamic, you can define your scraper in Ruby:

```ruby
class GoogleRecipe < ScraperKit::Recipe
  title "Google Search"
  on %r{https://www\.google\.com/search\?q=.+} do |doc, url|
    doc.xpath('//h3/a').collect {|node| node.text }
  end
end
```

Then load the recipe into IGRecipeRegistry and parse the page:
```objective-c
#import "IGScraperKit.h"

// load the recipe
NSString* path = [[NSBundle mainBundle] pathForResource:@"google" ofType:@"rb"];
NSString* recipe = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
IGRecipeRegistry* registry = [[IGRecipeRegistry alloc] init];
[registry loadRecipe:Recipe(@"walmart")];

NSArray* result = [registry scrapeWithHTML:html url:@"https://www.google.com/search?q=doughnuts"];
```

To enable this, define IGSCRAPERKIT_ENABLE_SCRIPTING in your pch file or preprocessor macro before import IGScraperKit.h.

## Installation

To install IGScraperKit throught [CocoaPods](http://cocoapods.org/), add following lines to your Podfile:

```ruby
pod "IGScraperKit", :podspec => 'https://raw.github.com/siuying/IGScraperKit/master/IGScraperKit.podspec'
```

Or with Ruby supports:

```ruby
pod "IGScraperKit/Scripting", :podspec => 'https://raw.github.com/siuying/IGScraperKit/master/IGScraperKit.podspec'
```

## Dependencies

- IGScraperKit use IGHTMLQuery for HTML processing.
- IGScraperKit optionally use JavaScriptCore in iOS 7 for JavaScript support.

## Development

1. In the project folder, run the command: ``pod install``

## License

MIT License. Check LICENSE.txt.