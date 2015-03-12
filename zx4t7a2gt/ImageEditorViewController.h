//
//  ImageEditorViewController.h
//  zx4t7a2gt
//
//  Created by User on 12/03/15.
//  Copyright (c) 2015 Endo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageEditorViewControllerUISetupProtocol <NSObject>

@required

- (void) setupUI;

@end

@interface ImageEditorViewController : UIViewController

@property (nonatomic, weak) id<ImageEditorViewControllerUISetupProtocol> delegate;

@end
