//
//  ViewController.m
//  zx4t7a2gt
//
//  Created by User on 19/01/15.
//  Copyright (c) 2015 Endo. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(processImage)];
    
    UIImage *testIm= [UIImage imageNamed:@"testImage"];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setImage:testIm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) processImage {
    
}

@end
