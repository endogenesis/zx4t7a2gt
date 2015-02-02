//
//  ImageProcessor.m
//  zx4t7a2gt
//
//  Created by NIkolay Tsygankov on 03.02.15.
//  Copyright (c) 2015 Endo. All rights reserved.
//

#import "ImageProcessor.h"


#pragma mark - Private

@implementation ImageProcessor

- (UIImage *) testProcessor:(UIImage *) image {
    
    static int SUPER = 1;
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 *pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    UInt32 *copyPixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    memcpy(copyPixels, pixels, height * width*sizeof(UInt32));
    
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )
    
    UInt32 * currentPixel = pixels;
    UInt32 * currentDXPixel = copyPixels;
    currentDXPixel+= 10;
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width-10; i++) {
            UInt32 color = *currentPixel;
            
            UInt32 dxColor = *currentDXPixel;
            UInt8 red =  R(color);
            UInt8 green = G(dxColor);
            UInt8 blue = B(color);
            UInt8 alpha = A(color);
            UInt32 newColor = RGBAMake(red, green, blue, alpha);
            memcpy(currentPixel, &newColor, sizeof(UInt32));
            currentPixel++;
        }
    }
    
    SUPER++;
    
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
    free(pixels);
    free(copyPixels);
    return processedImage;
}

@end
