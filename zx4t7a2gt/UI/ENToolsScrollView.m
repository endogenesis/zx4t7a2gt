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

@property (strong, nonatomic) NSArray *toolsArray;
@property (strong, nonatomic) ENToolView *activeTool;

@end

static  NSUInteger const kToolPadding = 5;

@implementation ENToolsScrollView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
        [_scrollView addGestureRecognizer:tapRecognizer];
    }
    return self;
}

#pragma mark - Touch

- (void) scrollViewTapped:(UITapGestureRecognizer *) recognizer {
    
    CGPoint locationInView = [recognizer locationInView:recognizer.view];
    
    [self.toolsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        if (CGRectContainsPoint(view.frame, locationInView)) {
            // MainViewController must change here
            *stop = YES;
        }
    }];
}

@end
