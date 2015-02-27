//
//  ImageProcessor.m
//  zx4t7a2gt
//
//  Created by NIkolay Tsygankov on 03.02.15.
//  Copyright (c) 2015 Endo. All rights reserved.
//

#import "ImageProcessor.h"


#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x ) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )

@interface ImageProcessor ()

@property (nonatomic, assign) CGContextRef context;
@property (nonatomic, assign) CGColorSpaceRef colorSpace;

@property (nonatomic, assign, readonly) NSUInteger bytesPerPixel;
@property (nonatomic, assign, readonly) NSUInteger byresPerRow;
@property (nonatomic, assign, readonly) NSUInteger bitsPerComponent;
@property (nonatomic, assign, readonly) NSUInteger pixelsCount;

@property (nonatomic, assign, readonly) NSUInteger width;
@property (nonatomic, assign, readonly) NSUInteger height;

@property (nonatomic, assign) UInt32 *pixels;
@property (nonatomic, assign) UInt32 *copyPixels;

@end


@implementation ImageProcessor

- (id) initWithImage:(UIImage *) image {
    self = [super init];
    if (self) {
        
        CGImageRef inputImage = image.CGImage;
        
        [self calculateContextParameters:inputImage];
        _pixels = calloc(_pixelsCount, sizeof(UInt32));
        _copyPixels = calloc(_pixelsCount, sizeof(UInt32));
        
        _colorSpace = CGColorSpaceCreateDeviceRGB();
        
        _context = CGBitmapContextCreate(_pixels, _width, _height, _bitsPerComponent, _byresPerRow, _colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGContextDrawImage(_context, CGRectMake(0, 0, _width, _height), inputImage);
        
        CGImageRelease(inputImage);
    }
    return self;
}

- (UIImage *) shuffleChannels {
    
    memcpy(_copyPixels, _pixels, _pixelsCount * sizeof(UInt32));
    
    NSDate *methodStart = [NSDate date];
    
    UInt32 *currentPixel = _pixels;
    
    int redDx = arc4random() % 41 - 20;
    int redDy = arc4random() % 41 - 20;
    
    int greenDx = arc4random() % 41 - 20;
    int greenDy = arc4random() % 41 - 20;
    
    int blueDx = arc4random() % 41 - 20;
    int blueDy = arc4random() % 41 - 20;
    
    for (int j = 0; j < _height; j++) {
        for (int i = 0; i < _width; i++) {
            UInt8 red = R([self getPixelAtX:(i+redDx) andY:(j+redDy)]);
            UInt8 green = G([self getPixelAtX:(i+greenDx) andY:(j+greenDy)]);
            UInt8 blue = B([self getPixelAtX:(i+blueDx) andY:(j+blueDy)]);
            UInt8 alpha = A(*currentPixel);
            
            UInt32 newColor = RGBAMake(red, green, blue, alpha);
            memcpy(currentPixel, &newColor, sizeof(UInt32));
            currentPixel++;
        }
    }
    
    CGImageRef outCGImage = CGBitmapContextCreateImage(_context);
    UIImage *outImage = [UIImage imageWithCGImage:outCGImage];
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"executionTime = %f", executionTime);
    
    return outImage;
}


- (UIImage *) moveChannel:(ENChannelType) channel OnDx:(NSInteger) dx andDy:(NSInteger) dy {
    
    memcpy(_copyPixels, _pixels, _pixelsCount * sizeof(UInt32));
    
    NSDate *methodStart = [NSDate date];
    
    UInt32 *currentPixel = _pixels;
    
    for (int j = 0; j < _height; j++) {
        for (int i = 0; i < _width; i++) {
            
            UInt8 red, green, blue, alpha;
            UInt32 pixelFromOldImage = [self getPixelAtX:(i + dx) andY:(j + dy)];
            
            if (channel & ENChannelRed)       red = R(pixelFromOldImage);   else red = R(*currentPixel);
            if (channel & ENChannelGreen)   green = G(pixelFromOldImage); else green = G(*currentPixel);
            if (channel & ENChannelBlue)     blue = B(pixelFromOldImage);  else blue = B(*currentPixel);
            if (channel & ENChannelAlpha)   alpha = A(pixelFromOldImage); else alpha = A(*currentPixel);
            
            UInt32 newColor = RGBAMake(red, green, blue, alpha);
            memcpy(currentPixel, &newColor, sizeof(UInt32));
            
            currentPixel++;
        }
    }
    
    CGImageRef outCGImage = CGBitmapContextCreateImage(_context);
    UIImage *outImage = [UIImage imageWithCGImage:outCGImage];
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"executionTime = %f", executionTime);
    
    return outImage;
}

- (UIImage *) imageWithScanLines:(CGFloat) width :(UIColor *) color {
    
    CGContextSaveGState(_context);
    
    CGContextSetStrokeColorWithColor(_context, color.CGColor);
    CGContextSetLineWidth(_context, width);
    
    for (int i = 1; i <_height; i+=width * 2) {
        
        CGContextMoveToPoint(_context, 0, i);
        CGContextAddLineToPoint(_context, _width, i);
        CGContextDrawPath(_context, kCGPathStroke);
    }
    
    CGImageRef outCGImage = CGBitmapContextCreateImage(_context);
    UIImage *outImage = [UIImage imageWithCGImage:outCGImage];
    
    CGContextRestoreGState(_context);
    
    return  outImage;
}

- (void) restorePrevious {
    memcpy(_pixels, _copyPixels, _pixelsCount * sizeof(UInt32));
}

#pragma mark Private

- (void) calculateContextParameters:(CGImageRef) inputImage {
    
    _width = CGImageGetWidth(inputImage);
    _height = CGImageGetHeight(inputImage);
    
    _bytesPerPixel = CGImageGetBitsPerPixel(inputImage)/8;
    _byresPerRow = _bytesPerPixel * _width;
    _bitsPerComponent = CGImageGetBitsPerComponent(inputImage);
    _pixelsCount = _width * _height;
}

- (UInt32) getPixelAtX:(NSInteger) x andY:(NSInteger) y {
    
   // x = -x;
   // y = -y;
    
    if (x < 0) x = _width + x;
    else if (x >= _width) x = x - _width;
    if (y < 0) y = _height + y;
        else if (y >= _height) y = y - _height;
    
    UInt32 *returnPixel = _copyPixels;
    NSUInteger dataOffset = x + _width * (y - 1);
    returnPixel += dataOffset;
    return *returnPixel;
}


@end
