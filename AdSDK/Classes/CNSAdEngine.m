//
//  AdEngine.m
//  AdSDK
//
//  Created by Thomas Dohmke on 29.03.10.
//  Copyright Codenauts UG 2010. All rights reserved.
//

#import "CNSAdEngine.h"
#import "CNSAdEngineConnectionHelper.h"
#import "CNSAdEngineParser.h"
#import "CNSStringAdditions.h"

@implementation CNSAdEngine

#pragma mark -
#pragma mark Helper Methods

+ (NSString *)baseURL {
  return @"http://adserver_live.yoc.mobi/interface/soapAdServerV3.php";
}

#pragma mark -
#pragma mark Public API

- (id)initWithDelegate:(id)aDelegate {
  if (self = [super init]) {
		delegate = aDelegate;
  }
  return self;
}

- (void)stop {
  delegate = nil;
}

- (void)dealloc {
  [self stop];
  [super dealloc];
}

- (void)requestAdForAdSpaceID:(NSString *)adSpaceID login:(NSString *)login password:(NSString *)password identifier:(NSString *)identifier {
	NSInteger maxImageWidth = 1024;
  if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location == NSNotFound) {
    maxImageWidth = [UIScreen mainScreen].bounds.size.width;
  }
  
	NSString *keywordsNoKeyword = @"NOKEYWORDS";
	NSString *body = [NSString stringWithFormat:
										@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                    "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://adserver_live.yoc.mobi/interface/soapAdServerV3.php\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://adserver_live.yoc.mobi/interface\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"
                    "<SOAP-ENV:Body>\n"
                    "<ns1:doAdRequestRawWithParams>\n"
                    "<adspace_id xsi:type=\"xsd:integer\">%@</adspace_id>\n"
                    "<request_params xsi:type=\"ns2:AdRequestParams\">\n"
                    "<maxImgWidth xsi:type=\"xsd:integer\">%d</maxImgWidth>\n"
                    "<keyword xsi:type=\"xsd:string\">%@</keyword>\n"
                    "</request_params>\n"
                    "</ns1:doAdRequestRawWithParams>\n"
                    "</SOAP-ENV:Body>\n"
                    "</SOAP-ENV:Envelope>\n", adSpaceID, maxImageWidth, keywordsNoKeyword];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[CNSAdEngine baseURL]]];
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPMethod:@"POST"];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
	[request addValue:@"ISO-8859-1,utf-8;q=0.7,*;q=0.7"	forHTTPHeaderField:@"Accept-Charset"];
	
	NSData *authorization	= [[NSString stringWithFormat:@"%@:%@", login, password] dataUsingEncoding:NSUTF8StringEncoding];
	NSString *authorizationBase64 = [NSString stringWithFormat:@"Basic %@",[NSString base64StringFromData:authorization length:[authorization length]]];
	[request addValue:authorizationBase64	forHTTPHeaderField:@"Authorization"];
	
	NSString *messageLength = [NSString stringWithFormat:@"%d", [body length]];
	[request addValue:messageLength forHTTPHeaderField:@"Content-Length"];
	
  NSString *userAgent;
  if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location == NSNotFound) {
    userAgent = [NSString stringWithFormat:@"Mozilla/5.0 (%@; U; CPU like Mac OS X; en) AppleWebKit/420.1 (KHTML, like Gecko) Version/%@ Mobile/3A110a Safari/419.3", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion]];
  }
  else {
    userAgent = [NSString stringWithFormat:@"Mozilla/5.0 (iPad; U; CPU OS OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/%@ Mobile/7B367 Safari/531.21.10", [[UIDevice currentDevice] systemVersion]];
  }
	[request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
	
	connectionHelper = [[CNSAdEngineConnectionHelper alloc] initWithRequest:request delegate:self identifier:identifier];
}

- (void)requestAdForAdSpaceID:(NSString *)adSpaceID login:(NSString *)login password:(NSString *)password {
  [self requestAdForAdSpaceID:adSpaceID login:login password:password identifier:adSpaceID];
}

#pragma mark -
#pragma mark AdEngineConnectionHelper Delegate Methods

- (void)connectionDidFail:(CNSAdEngineConnectionHelper *)aConnectionHelper {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
  if ([delegate respondsToSelector:@selector(adEngineDidFail:)]) {
    [delegate performSelectorOnMainThread:@selector(adEngineDidFail:) withObject:aConnectionHelper.identifier waitUntilDone:YES];
  }
	
  [aConnectionHelper release];
	[pool drain];
}

- (void)connectionDidLoadData:(CNSAdEngineConnectionHelper *)aConnectionHelper {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

#ifdef DEBUG
  NSString *responseString = [[[NSString alloc] initWithData:aConnectionHelper.data encoding:NSUTF8StringEncoding] autorelease];
  NSLog(@"%@", responseString);
#endif
  
	NSMutableDictionary *userInfo = [[[NSMutableDictionary alloc] init] autorelease];
	[userInfo setValue:aConnectionHelper.identifier forKey:@"identifier"];

  CNSAdEngineParser *parser = [[[CNSAdEngineParser alloc] initWithData:aConnectionHelper.data] autorelease];
  if ([parser parse]) {
    if (parser.imageURL) {
      NSData *imageData = [NSData dataWithContentsOfURL:parser.imageURL];
      [userInfo setValue:imageData forKey:@"imageData"];
      [userInfo setValue:[UIImage imageWithData:imageData] forKey:@"image"];
      [userInfo setValue:parser.imageURL forKey:@"imageURL"];
    }
    
    if (parser.alt) {
      NSArray *components = [parser.alt componentsSeparatedByString:@";"];
      for (NSString *component in components) {
        if ([component rangeOfString:@"*click"].location != NSNotFound) {
          [userInfo setValue:[NSNumber numberWithBool:YES] forKey:@"waitForUser"];
        }
        else if ([component rangeOfString:@"twidth"].location != NSNotFound) {
          [userInfo setValue:[component substringFromIndex:6] forKey:@"targetWidth"];
        }
        else if ([component rangeOfString:@"theight"].location != NSNotFound) {
          [userInfo setValue:[component substringFromIndex:7] forKey:@"targetHeight"];
        }
        else if ([component rangeOfString:@"url"].location != NSNotFound) {
          [userInfo setValue:[component substringFromIndex:4] forKey:@"exitURL"];
        }
      }
    }

    [userInfo setValue:parser.targetURL forKey:@"targetURL"];
  }
	
  if ([delegate respondsToSelector:@selector(adEngineDidReceiveBanner:)]) {
    [delegate performSelectorOnMainThread:@selector(adEngineDidReceiveBanner:) withObject:userInfo waitUntilDone:YES];
  }
	
	[aConnectionHelper release];
	[pool drain];
}

@end
