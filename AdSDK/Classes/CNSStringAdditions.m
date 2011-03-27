//
//  NSString+KDENSStringAdditions.m
//  AdSDK
//
//  Created by Thomas Dohmke on 29.03.10.
//  Copyright Codenauts UG 2010. All rights reserved.
//

#import "CNSStringAdditions.h"

static char base64EncodingTable[64] = {
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
  'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
  'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
  'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (CNSStringAdditions)

+ (NSString *)urlEncodedStringFromString:(NSString *)string {
	NSString *encoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	return [encoded autorelease];
}

+ (NSString *)base64StringFromData:(NSData *)data length:(NSInteger)length {
	NSMutableString *result  = nil;
	unsigned char input[3];
  unsigned char output[4];
	unsigned long textIndex;
  unsigned long textLength;
	long remaining = 0;
  short copy = 0;
  short charsOnLine = 0;
	const unsigned char *raw;
	
	textLength = [data length]; 
	if (textLength < 1) {
		return @"";
	}
	result = [NSMutableString stringWithCapacity: textLength];
	raw = [data bytes];
	textIndex = 0; 
	
	while (true) {
		remaining = textLength - textIndex;
		if (remaining <= 0) {
			break;        
		}
		
		for (short index = 0; index < 3; index++) { 
			unsigned long rawIndex = textIndex + index;
			if (rawIndex < textLength) {
				input[index] = raw[rawIndex];
			}
			else {
				input[index] = 0;
			}
		}
    
		output[0] = (input[0] & 0xFC) >> 2;
		output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
		output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
		output[3] = input[2] & 0x3F;
    copy = (remaining == 1 ? 2 : (remaining == 2 ? 3 : 4));
		
		for (short index = 0; index < copy; index++) {
			[result appendString:[NSString stringWithFormat:@"%c", base64EncodingTable[output[index]]]];
		}
		
		for (short index = copy; index < 4; index++) {
			[result appendString:@"="];
		}
		
		textIndex += 3;
		charsOnLine += 4;
		
		if ((length > 0) && (charsOnLine >= length)) {
			charsOnLine = 0;
		}
	}
	return result;
}

@end
