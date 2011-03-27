//
//  AdEngine.h
//  AdSDK
//
//  Created by Thomas Dohmke on 29.03.10.
//  Copyright Codenauts UG 2010. All rights reserved.
//

@class CNSAdEngineConnectionHelper;

@interface CNSAdEngine : NSObject {
@private
	id delegate;
  CNSAdEngineConnectionHelper *connectionHelper;
}

- (id)initWithDelegate:(id)aDelegate;

- (void)requestAdForAdSpaceID:(NSString *)adSpaceID login:(NSString *)login password:(NSString *)password;
- (void)requestAdForAdSpaceID:(NSString *)adSpaceID login:(NSString *)login password:(NSString *)password identifier:(NSString *)identifier;

- (void)stop;

@end
