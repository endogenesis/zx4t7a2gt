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

- (UIImage *) shuffleChannels;
- (id) initWithImage:(UIImage *) image;
- (UIImage *) moveChannel:(ENChannelType) channel OnDx:(NSInteger) dx andDy:(NSInteger) dy;
- (UIImage *) moveRedChannelOnDx:(NSInteger) dx andDy:(NSInteger) dy;
- (UIImage *) moveGreenChannelOnDx:(NSInteger) dx andDy:(NSInteger) dy;
- (UIImage *) moveBlueChannelOnDx:(NSInteger) dx andDy:(NSInteger) dy;

@end
