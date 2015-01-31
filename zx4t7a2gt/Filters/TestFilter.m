//
//  TestFilter.m
//  zx4t7a2gt
//
//  Created by NIkolay Tsygankov on 31.01.15.
//  Copyright (c) 2015 Endo. All rights reserved.
//

#import "TestFilter.h"

@implementation TestFilter

- (CIColorKernel *)myKernel {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SwapRedAndGreen"
                                                     ofType:@"cikernel"];
    NSString *kernelStr = [NSString stringWithContentsOfFile:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    static CIColorKernel *kernel = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        kernel = [CIColorKernel kernelWithString:kernelStr];
    });
    return kernel;
}

- (CIImage *)outputImage
{
    CGRect dod = self.inputImage.extent ;
    return [[self myKernel] applyWithExtent:dod
                                  arguments:@[self.inputImage, self.inputAmount]];
}


@end
