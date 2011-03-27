//
//  AdEngineParser.h
//  AdSDK
//
//  Created by Thomas Dohmke on 13.04.10.
//  Copyright Codenauts UG 2010. All rights reserved.
//

@interface CNSAdEngineParser : NSObject <NSXMLParserDelegate> {
  NSXMLParser *xmlParser;
  NSMutableString *currentString;
  NSString *alt;
  NSURL *imageURL;
  NSURL *targetURL;
}

@property (copy) NSString *alt;
@property (copy) NSURL *imageURL;
@property (copy) NSURL *targetURL;

- (id)initWithData:(NSData *)data;
- (BOOL)parse;

@end
