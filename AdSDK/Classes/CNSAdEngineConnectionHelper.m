//
//  AdConnectionHelper.m
//  AdSDK
//
//  Created by Thomas Dohmke on 29.03.10.
//  Copyright Codenauts UG 2010. All rights reserved.
//

#import "CNSAdEngineConnectionHelper.h"
#import "CNSStringAdditions.h"

@implementation CNSAdEngineConnectionHelper

@synthesize data;
@synthesize identifier;

#pragma mark -
#pragma mark Initialization

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)aDelegate identifier:(NSString *)anIdentifier {
  if (self = [super init]) {
    delegate = [aDelegate retain];
    identifier = [anIdentifier copy];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];  
    data = [[NSMutableData alloc] init];
  }
  return self;
}

#pragma mark -
#pragma mark Memory Management Methods

- (void)dealloc {
  [connection release];
  [data release];
	[identifier release];

  [delegate release];
  delegate = nil;

  [super dealloc];
}

#pragma mark -
#pragma mark Connection Delegate Methods

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)response {
	[data setLength:0];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)receivedData {
	[data appendData:receivedData];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
	SEL selector = @selector(connectionDidFail:);
  if ([delegate respondsToSelector:selector]) {
    [delegate performSelector:selector withObject:self];
  }
  
  [delegate release];
  delegate = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	SEL selector = @selector(connectionDidLoadData:);
  if ([delegate respondsToSelector:selector]) {
    [delegate performSelectorInBackground:selector withObject:self];
  }
  
  [delegate release];
  delegate = nil;
}

@end