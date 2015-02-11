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

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) ImageProcessor *processor;

@property (strong, nonatomic) IBOutlet UISlider *slider;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(processImage:)];
    
    //UIImage *testIm= [UIImage imageNamed:@"testImage"];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setImage:[UIImage imageNamed:@"test"]];
    self.processor = [[ImageProcessor alloc] initWithImage:self.imageView.image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSliderValueChanged:(id)sender {
    

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        UIImage *newImage = [_processor shuffleChannels];
//        dispatch_async(dispatch_get_main_queue(), ^{
//              [self.imageView setImage:newImage];
//        });
//
//    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *newImage = [_processor shuffleChannels];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:newImage];
        });
        
    });

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

@end
