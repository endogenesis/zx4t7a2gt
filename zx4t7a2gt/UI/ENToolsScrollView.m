//
//  ENToolsScrollView.m
//  zx4t7a2gt
//
//  Created by User on 11/03/15.
//  Copyright (c) 2015 Endo. All rights reserved.
//

#import "ENToolsScrollView.h"
#import "ENToolView.h"

@interface ENToolsScrollView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) ENToolView *activeTool;

@end

static CGFloat const kToolPadding = 5;
static CGFloat const kToolDimension = 50;

@implementation ENToolsScrollView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
        [_scrollView addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void) loadScrollItems {
    
    if (!self.delegate) {
        return;
    }
    
    CGFloat startX = kToolPadding;
    
    for (int i = 0; i < [self.delegate numberOfViewsForToolsScrollView:self]; i++) {
        UIView *view = [self.delegate toolsScrollView:self viewAtIndex:i];
        [view setFrame:CGRectMake(startX, kToolPadding, kToolDimension, kToolDimension)];
        [self addSubview:view];
        startX += kToolDimension + kToolPadding;
    }
    
    [self.scrollView setContentSize:CGSizeMake(startX + kToolPadding, CGRectGetHeight(self.frame))];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
}

#pragma mark - Touch

- (void) scrollViewTapped:(UITapGestureRecognizer *) recognizer {
    
    CGPoint locationInView = [recognizer locationInView:recognizer.view];
    
    for (int i = 0; i < [self.delegate numberOfViewsForToolsScrollView:self]; i++) {
        
        UIView *view = [self.delegate toolsScrollView:self viewAtIndex:i];
        
        if (CGRectContainsPoint(view.frame, locationInView)) {
            [self.delegate toolsScrollView:self clickedViewAtIndex:i];
            CGPoint offset = CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0);
            [self.scrollView setContentOffset:offset animated:YES];
        }
    }
}

@end
