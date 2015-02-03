//
//  ImageProcessor.m
//  zx4t7a2gt
//
//  Created by NIkolay Tsygankov on 03.02.15.
//  Copyright (c) 2015 Endo. All rights reserved.
//

#import "ImageProcessor.h"


#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )


#pragma mark - Private

@interface ImageProcessor ()

{
    int width, height;
    UInt32 *copyPixels;
}


@end

@implementation ImageProcessor

- (UIImage *) moveRedChannelWithXOffset:(int) dx YOffset:(int) dy {
    
    
    NSDate *methodStart = [NSDate date];
    
    /* ... Do whatever you need to do ... */
    
    
    CGImageRef inputCGImage = [_image CGImage];
    width = (int)CGImageGetWidth(inputCGImage);
    height = (int)CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger pixelsCount = width * height;
    
    UInt32 *pixels;
    pixels = (UInt32 *) calloc(pixelsCount, sizeof(UInt32));
    copyPixels = (UInt32 *) calloc(pixelsCount, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    memcpy(copyPixels, pixels, pixelsCount * sizeof(UInt32));
    
    UInt32 *currentPixel = pixels;
    
    for (int j = 0; j < height; j++) {
        for (int i = 0; i < width; i++) {
            
            UInt32 color = *currentPixel;
            UInt32 dxColor = [self getPixelAtX:(i+dx) andY:(j+dy)] ;
            UInt8 red =  R(dxColor);
            UInt8 green = G(color);
            UInt8 blue = B(color);
            UInt8 alpha = A(color);
            UInt32 newColor = RGBAMake(red, green, blue, alpha);
            memcpy(currentPixel, &newColor, sizeof(UInt32));
            currentPixel++;
        }
    }
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
    free(pixels);
    free(copyPixels);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"executionTime = %f", executionTime);

    return processedImage;
}


- (UInt32) getPixelAtX:(int) x andY:(int) y {
    
    if (x < 0) x = width + x;
    else if (x >= width) x = x - width;
    if (y < 0) y = height + y;
        else if (y >= height) y = y - height;
    
    UInt32 *returnPixel = copyPixels;
    NSUInteger dataOffset = x + width * (y - 1);
    returnPixel += dataOffset;
    return *returnPixel;
}


@end
