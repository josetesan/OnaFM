//
//  AdConnectionHelper.h
//  AdSDK
//
//  Created by Thomas Dohmke on 29.03.10.
//  Copyright Codenauts UG 2010. All rights reserved.
//

@interface CNSAdEngineConnectionHelper : NSObject {
@private
  id delegate;
  NSMutableData *data;
	NSString *identifier;
  NSURLConnection *connection;
}

@property (retain, readonly) NSMutableData *data;
@property (retain, readonly) NSString *identifier;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)aDelegate identifier:(NSString *)anIdentifier;

@end
