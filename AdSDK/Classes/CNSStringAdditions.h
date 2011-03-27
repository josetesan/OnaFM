//
//  NSString+KDENSStringAdditions.h
//  AdSDK
//
//  Created by Thomas Dohmke on 29.03.10.
//  Copyright Codenauts UG 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (CNSStringAdditions)

+ (NSString *)urlEncodedStringFromString:(NSString *)string;
+ (NSString *)base64StringFromData:(NSData *)data length:(NSInteger)length;

@end
