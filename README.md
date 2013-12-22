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

IGScraperKit supports JavaScriptCore from iOS 7, you can create scraper by using JavaScript:

```
IGScraper* scraper = [IGScraper scraperWithJavaScript:@"node.queryWithXPath('//p').firstObject().text()"];
```

To enable this, define IGSCRAPERKIT_JAVASCRIPT_ADDITIONS in your pch file or preprocessor macro before import IGScraper.

## Dependencies

- IGScraperKit use IGHTMLQuery for HTML processing.
- IGScraperKit optionally use JavaScriptCore in iOS 7 for JavaScript support.

## Development

1. In the project folder, run the command: ``pod install``

## License

MIT License. Check LICENSE.txt.