//
//  ImageProcessor.h
//  zx4t7a2gt
//
//  Created by NIkolay Tsygankov on 03.02.15.
//  Copyright (c) 2015 Endo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageProcessor : NSObject

@property (nonatomic, weak) UIImage *image;

- (UIImage *) shuffleChannels;
- (id) initWithImage:(UIImage *) image;

@end
