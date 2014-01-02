# IGScraperKit

Create dynamic web scraper in Objective-C, using block or JavaScript.

## Usage

Create a scraper:

```
IGScraper* scraper = [IGScraper scraperWithBlock:^id(IGXMLNode* node) {
                return [[[node queryWithXPath:@"//p"] firstObject] text];
            }];
```

Then scrape HTML with scraper:

```
[scraper scrape:@"<html><p>Hello World</p></html>"];
```

IGScraperKit supports JavaScriptCore from iOS 7, you can create scraper by using JavaScript or Ruby:

```javascript
IGScraper* scraper = [IGScraper scraperWithJavaScript:@"node.queryWithXPath('//p').firstObject().text()"];
```

```ruby
IGScraper* scraper = [IGScraper scraperWithRuby:@"node.xpath('//p').first.text"];
```

To enable this, define IGSCRAPERKIT_ENABLE_SCRIPTING in your pch file or preprocessor macro before import IGScraper.

## Installation

To install IGScraperKit throught [CocoaPods](http://cocoapods.org/), add following lines to your Podfile:

```ruby
pod "IGScraperKit", :podspec => 'https://raw.github.com/siuying/IGScraperKit/master/IGScraperKit.podspec'
```

Or with JavaScript/Ruby supports:

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