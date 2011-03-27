//
//  AdEngineParser.m
//  AdSDK
//
//  Created by Thomas Dohmke on 13.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CNSAdEngineParser.h"

@implementation CNSAdEngineParser

@synthesize alt;
@synthesize imageURL;
@synthesize targetURL;

- (id)initWithData:(NSData *)data {
  if (self = [super init]) {
    xmlParser = [[NSXMLParser alloc] initWithData:data];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
  }
  return self;
}

- (BOOL)parse {
  return [xmlParser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if (!currentString) {
		currentString = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqualToString:@"alt"]){
		self.alt = currentString;
  }
  
	if ([elementName isEqualToString:@"imgUrl"]){
		self.imageURL = [NSURL URLWithString:currentString];
	}
	
	if ([elementName isEqualToString:@"targetUrl"]){
		self.targetURL = [NSURL URLWithString:currentString];
	}
	
	[currentString release];
	currentString = nil;
}

- (void)dealloc {
  self.alt = nil;
  self.imageURL = nil;
  self.targetURL = nil;
  
  [xmlParser release];
  [currentString release];
  
  [super dealloc];
}

@end
