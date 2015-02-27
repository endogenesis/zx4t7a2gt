//
//  ImageProcessor.h
//  zx4t7a2gt
//
//  Created by NIkolay Tsygankov on 03.02.15.
//  Copyright (c) 2015 Endo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ENChannelType) {
    ENChannelNone  = 0,
    ENChannelRed   = 1 << 0,
    ENChannelGreen = 1 << 1,
    ENChannelBlue  = 1 << 2,
    ENChannelAlpha = 1 << 3
};

@interface ImageProcessor : NSObject

@property (nonatomic, weak) UIImage *image;

- (id) initWithImage:(UIImage *) image;

//filters
- (UIImage *) moveChannel:(ENChannelType) channel OnDx:(NSInteger) dx andDy:(NSInteger) dy;
- (UIImage *) imageWithScanLines:(CGFloat) width :(UIColor *) color;
- (UIImage *) shuffleChannels;

//utils
- (void) restorePrevious;

@end
