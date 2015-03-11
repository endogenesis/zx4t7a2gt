//
//  ViewController.m
//  zx4t7a2gt
//
//  Created by User on 19/01/15.
//  Copyright (c) 2015 Endo. All rights reserved.
//
#import "TestFilter.h"
#import "MainViewController.h"
#import "ImageProcessor.h"
#import "ASMediaFocusManager.h"

@interface MainViewController () <ASMediasFocusDelegate>

{
    dispatch_queue_t serial_que;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) ImageProcessor *processor;
@property (strong, nonatomic) IBOutlet UISlider *slider;

@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(processImage:)];
    
    serial_que = dispatch_queue_create("endo_serial_que", 0);
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setImage:[UIImage imageNamed:@"testImage"]];
    
    self.processor = [[ImageProcessor alloc] initWithImage:self.imageView.image];
    
    
    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    self.mediaFocusManager.delegate = self;
    // Tells which views need to be focusable. You can put your image views in an array and give it to the focus manager.
    [self.mediaFocusManager installOnView:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSliderValueChanged:(id)sender {
    
    
    dispatch_async(serial_que, ^{
        [_processor shuffleChannels];
        UIImage *newImage = [_processor imageWithScanLines:3.0 :[UIColor blackColor]];
        [_processor restorePreviousImageState];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:newImage];
        });
        
    });
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        UIImage *newImage = [_processor shuffleChannels];
//        [_processor restorePrevious];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.imageView setImage:newImage];
//        });
//        
//    });
}

- (void) processImage:(CGFloat) amount {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        
        TestFilter *swapRedAndGreenFilter = [[TestFilter alloc] init];
        swapRedAndGreenFilter.inputAmount = [[NSNumber alloc] initWithFloat:amount];
        
        CIImage *ciImage = [[CIImage alloc] initWithImage:self.imageView.image];
        [swapRedAndGreenFilter setValue:ciImage forKey:kCIInputImageKey];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [swapRedAndGreenFilter outputImage];
        CGImageRef cgImage = [context createCGImage:outputImage
                                           fromRect:[outputImage extent]];
        UIImage *outImage = [UIImage imageWithCGImage:cgImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = outImage;
        });
    });
    
}

#pragma mark ASMediaFocusManager 
- (UIImageView *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageViewForView:(UIView *)view
{
    return (UIImageView *)view;
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameForView:(UIView *)view
{
    return self.parentViewController.view.bounds;
}

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return self.parentViewController;
}


- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view
{
    return @"My title";
}


@end
