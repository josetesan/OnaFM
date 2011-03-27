//
//  CNSAdConstants.h
//  AdSDK
//
//  Created by Thomas Dohmke on 22.07.10.
//  Copyright 2010 Codenauts UG. All rights reserved.
//

@interface CNSAdConstants : NSObject {
}

#pragma mark -
#pragma mark Constants

extern NSString *const CNSAdBannerTypeLandscape;
extern NSString *const CNSAdBannerTypePortrait;

extern NSString *const kCNSAdEngineLogin;
extern NSString *const kCNSAdEnginePassword;

#pragma mark -
#pragma mark Helper Macros

#ifndef kCNSCoreFoundationVersionNumberiOS32
#define kCNSCoreFoundationVersionNumberiOS32 478.61
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
#define CNS_IF_IOS32_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCNSCoreFoundationVersionNumberiOS32) { \
__VA_ARGS__ \
}
#else
#define CNS_IF_IOS32_OR_GREATER(...)
#endif

@end

