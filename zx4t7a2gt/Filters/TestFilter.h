//
//  TestFilter.h
//  zx4t7a2gt
//
//  Created by NIkolay Tsygankov on 31.01.15.
//  Copyright (c) 2015 Endo. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface TestFilter : CIFilter

@property (strong, nonatomic) CIImage *inputImage;
@property NSNumber *inputAmount;

@end
