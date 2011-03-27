//
//  CNSAnimatedGifLoader.m
//
//  Created by Stijn Spijker (http://www.stijnspijker.nl/) on 2009-07-03.
//  Based on gifdecode written april 2009 by Martin van Spanje, P-Edge media.
//  Modified by Thomas Dohmke on 2010-08-15.
//  
//  Changes on gifdecode:
//  - Small optimizations (mainly arrays)
//  - Object Orientated Approach (Class Methods as well as Object Methods)
//  - Added the Graphic Control Extension Frame for transparancy
//  - Changed header to GIF89a
//  - Added methods for ease-of-use
//  - Added animations with transparancy
//  - No need to save frames to the filesystem anymore
//
//  Changelog:
//
//	2010-03-16: Added queing mechanism for static class use
//  2010-01-24: Rework of the entire module, adding static methods, better memory management and URL asynchronous loading
//  2009-10-08: Added dealloc method, and removed leaks, by Pedro Silva
//  2009-08-10: Fixed double release for array, by Christian Garbers
//  2009-06-05: Initial Version
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//  

@interface CNSAnimatedGIFFrame : NSObject {
	NSData *data;
	NSData *header;
	double delay;
	int disposalMethod;
	CGRect area;
}

@property (nonatomic, copy) NSData *header;
@property (nonatomic, copy) NSData *data;

@property (nonatomic, assign) CGRect area;
@property (nonatomic, assign) double delay;
@property (nonatomic, assign) int disposalMethod;

@end

@interface CNSAnimatedGIFQueueObject : NSObject {
  UIImageView *uiv;
  NSURL *url;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) UIImageView *uiv;

@end

@interface CNSAnimatedGIFLoader : NSObject {
	bool busyDecoding;
	
	int animatedGifDelay;
	int dataPointer;
	int GIF_sorted;
	int GIF_colorS;
	int GIF_colorC;
	int GIF_colorF;
  
	NSData *GIF_pointer;

	NSMutableArray *GIF_frames;
  NSMutableArray *imageQueue;
	
  NSMutableData *GIF_buffer;
	NSMutableData *GIF_screen;
	NSMutableData *GIF_global;
  
  UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView* imageView;

@property (assign) bool busyDecoding;

+ (CNSAnimatedGIFLoader *)sharedInstance;
+ (UIImageView *)getAnimationForGifAtUrl:(NSURL *)animationURL;

- (bool)GIFGetBytes:(int)length;
- (bool)GIFSkipBytes:(int)length;

- (NSData *)getFrameAsDataAtIndex:(int)index;

- (UIImage *)getFrameAsImageAtIndex:(int)index;
- (UIImageView *)getAnimation;

- (void)addToQueue:(CNSAnimatedGIFQueueObject *)GIFObject;
- (void)decodeGIF:(NSData *)GIFData;
- (void)GIFReadExtensions;
- (void)GIFReadDescriptor;

@end
