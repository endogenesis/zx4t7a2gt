//
//  ENToolsScrollView.h
//  zx4t7a2gt
//
//  Created by User on 11/03/15.
//  Copyright (c) 2015 Endo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ENToolsScrollView;

@protocol ENToolsScrollViewProtocol <NSObject>
@required
- (NSInteger)numberOfViewsForToolsScrollView:(ENToolsScrollView *)scrollView;
- (UIView *)toolsScrollView:(ENToolsScrollView *)scrollView viewAtIndex:(NSUInteger)index;
- (void)toolsScrollView:(ENToolsScrollView *)scrollView clickedViewAtIndex:(NSUInteger)index;
@end

@interface ENToolsScrollView : UIView

@property(nonatomic, weak) id<ENToolsScrollViewProtocol> delegate;

- (void) loadScrollItems;

@end
