// DDGNavigationController.m
//
// Copyright (c) 2014 DU DA GMBH (http://www.dudagroup.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "DDGNavigationController.h"
#import "UIColor+DDGColorAdditions.h"
#import "DDGScreenEdgePanGestureRecognizer.h"


@implementation DDGNavigationController
{
    DDGScreenEdgePanGestureRecognizer* _screenEdgePanGestureRecognizer;
    NSMutableArray* _viewControllers;

    UIView* _contentView;
    UIView* _frontContentView;

    CGRect _contentRect;
    CGRect _backContentOffsetRect;
    CGRect _frontContentOffsetRect;
}

static const CGFloat DefaultContentParallaxFactor = 0.25f;
static const CGFloat DefaultAnimationDuration = 0.5f;

//==================================================================================================
// Init & Dealloc
//==================================================================================================

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        _parallaxFactor = DefaultContentParallaxFactor;
        _animationDuration = DefaultAnimationDuration;
    }

    return self;
}

- (instancetype)initWithRootViewController:(UIViewController*)viewController
{
    NSParameterAssert(viewController);

    self = [self init];

    if (self)
    {
        _viewControllers = [NSMutableArray array];
        [_viewControllers addObject:viewController];
    }

    return self;
}

//==================================================================================================
// Controller Lifecycle
//==================================================================================================

- (void)loadView
{
    [super loadView];

    _screenEdgePanGestureRecognizer =
        [[DDGScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(screenEdgePanAction:)];

    _screenEdgePanGestureRecognizer.edges = UIRectEdgeLeft;

    [self.view addGestureRecognizer:_screenEdgePanGestureRecognizer];

    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight;

    _frontContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _frontContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                         UIViewAutoresizingFlexibleHeight;

    _frontContentView.hidden = YES;

    _frontContentView.layer.shadowColor = [UIColor blackColor].CGColor;
    _frontContentView.layer.shadowRadius = 10.0f;
    _frontContentView.layer.shadowOpacity = 0.3f;
    _frontContentView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);

    [self.view addSubview:_contentView];
    [self.view addSubview:_frontContentView];

    UIViewController* topViewController = self.topViewController;

    [self addChildViewController:topViewController];

    topViewController.view.frame = self.view.bounds;
    topViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                              UIViewAutoresizingFlexibleHeight;

    [_contentView addSubview:topViewController.view];
    [topViewController didMoveToParentViewController:self];
}

- (void)screenEdgePanAction:(id)sender
{
    NSAssert(self.view.window.bounds.size.width, @"Window should have a width greater than 0!");

    if (_viewControllers.count <= 1) return;

    CGPoint translation = [_screenEdgePanGestureRecognizer translationInView:self.view];
    CGPoint velocity = [_screenEdgePanGestureRecognizer velocityInView:self.view];

    CGFloat percentage = MIN(MAX(translation.x / self.view.bounds.size.width, 0.0f), 1.0f);

    switch (_screenEdgePanGestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            [self startedPanning];
            break;

        case UIGestureRecognizerStateChanged:
            [self updatePanPercentage:percentage];
            break;

        case UIGestureRecognizerStateEnded:
            [self endedPanWithPercentage:percentage velocity:velocity.x];
            break;

        case UIGestureRecognizerStateCancelled:
            [self endedPanWithPercentage:percentage velocity:velocity.x];
            break;

        default:break;
    }
}

- (void)startedPanning
{

    UIViewController* topViewController = self.topViewController;
    UIViewController* backViewController = self.backViewController;

    [topViewController beginAppearanceTransition:NO animated:YES];
    [backViewController beginAppearanceTransition:YES animated:YES];

    [topViewController willMoveToParentViewController:nil];

    [_contentView addSubview:backViewController.view];
    [_frontContentView addSubview:topViewController.view];

    CGRect bounds = self.view.bounds;

    _contentView.frame = _backContentOffsetRect;
    _frontContentView.frame = _contentRect;

    _frontContentView.hidden = NO;
}

- (void)updatePanPercentage:(CGFloat)percentage
{
    CGRect bounds = self.view.bounds;

    CGRect contentStartFrame = CGRectOffset(bounds, -(bounds.size.width / 4.0f), 0.0f);
    CGRect contentTargetFrame = bounds;

    CGRect frontContentStartFrame = bounds;
    CGRect frontContentTargetFrame = CGRectOffset(bounds, bounds.size.width, 0.0f);

    _contentView.frame = CGRectMake(contentStartFrame.origin.x + ((contentTargetFrame.origin.x - contentStartFrame.origin.x) * percentage),
                                    contentTargetFrame.origin.y,
                                    contentTargetFrame.size.width,
                                    contentTargetFrame.size.height);

    _frontContentView.frame = CGRectMake(frontContentStartFrame.origin.x + ((frontContentTargetFrame.origin.x - frontContentStartFrame.origin.x) * percentage),
                                         frontContentTargetFrame.origin.y,
                                         frontContentTargetFrame.size.width,
                                         frontContentTargetFrame.size.height);
}

- (void)endedPanWithPercentage:(CGFloat)percentage velocity:(CGFloat)velocity
{
    UIViewController* topViewController = self.topViewController;
    UIViewController* backViewController = self.backViewController;

    NSLog(@"VELOCITY -> %f", velocity);

    CGRect bounds = self.view.bounds;

    void (^animations)() = nil;
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        _frontContentView.hidden = YES;

        _contentView.frame = bounds;

        if (percentage > 0.5f ||
            velocity > 100.0f)
        {
            [topViewController.view removeFromSuperview];
            [topViewController didMoveToParentViewController:nil];
            [_viewControllers removeLastObject];
        }
        else
        {
            [backViewController.view removeFromSuperview];
            [_contentView addSubview:topViewController.view];
        }

        [topViewController endAppearanceTransition];
        [backViewController endAppearanceTransition];
    };

    if (percentage > 0.5f ||
        velocity > 100.0f)
    {
        CGRect contentTargetFrame = bounds;
        CGRect frontContentTargetFrame = CGRectOffset(bounds, bounds.size.width, 0.0f);

        animations = ^
        {
            _contentView.frame = contentTargetFrame;
            _frontContentView.frame = frontContentTargetFrame;
        };
    }
    else
    {
        CGRect contentTargetFrame = CGRectOffset(bounds, -(bounds.size.width / 4.0f), 0.0f);
        CGRect frontContentTargetFrame = bounds;

        [topViewController beginAppearanceTransition:YES animated:YES];
        [backViewController beginAppearanceTransition:NO animated:YES];

        animations = ^
        {
            _contentView.frame = contentTargetFrame;
            _frontContentView.frame = frontContentTargetFrame;
        };
    }

    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:animations
                     completion:completion];
}


- (void)viewDidLayoutSubviews
{
    [self updateContentRects];

    _frontContentView.layer.shadowPath = CGPathCreateWithRect(self.view.bounds, nil);
}

- (void)updateContentRects
{
    _contentRect = self.view.bounds;
    _backContentOffsetRect = CGRectOffset(_contentRect, -(_contentRect.size.width * _parallaxFactor), 0.0f);
    _frontContentOffsetRect = CGRectOffset(_contentRect, _contentRect.size.width, 0.0f);
}

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    NSParameterAssert(viewController);

    [_viewControllers addObject:viewController];

    UIViewController* topViewController = self.topViewController;
    UIViewController* backViewController = self.backViewController;

    [self addChildViewController:topViewController];

    _frontContentView.frame = _frontContentOffsetRect;
    _frontContentView.hidden = NO;

    topViewController.view.frame = _frontContentView.bounds;
    topViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                              UIViewAutoresizingFlexibleHeight;

    [backViewController beginAppearanceTransition:NO animated:animated];
    [topViewController beginAppearanceTransition:YES animated:animated];

    [_frontContentView addSubview:topViewController.view];

    void (^animations)() = ^
    {
        _contentView.frame = _backContentOffsetRect;
        _frontContentView.frame = _contentRect;
    };

    void (^completion)(BOOL) = ^(BOOL finished)
    {
        [backViewController.view removeFromSuperview];
        [backViewController endAppearanceTransition];

        [_contentView addSubview:topViewController.view];

        _contentView.frame = self.view.bounds;
        _frontContentView.hidden = YES;

        [topViewController didMoveToParentViewController:self];
        [topViewController endAppearanceTransition];
    };

    if (animated)
    {
        [UIView animateWithDuration:0.25f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:animations
                         completion:completion];
    }
    else
    {
        animations();
        completion(YES);
    }
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

//==================================================================================================
// Properties
//==================================================================================================

- (void)setViewControllers:(NSArray*)viewControllers
{
    NSParameterAssert(viewControllers);

    _viewControllers = [viewControllers mutableCopy];
}

- (NSArray*)viewControllers
{
    return [_viewControllers copy];
}

- (UIViewController*)topViewController
{
    return [_viewControllers lastObject];
}

- (UIViewController*)backViewController
{
    if (_viewControllers.count < 2) return nil;
    return _viewControllers[_viewControllers.count - 2];
}

@end

@implementation UIViewController (DDGNavigationControllerAddition)

- (DDGNavigationController*)ddg_navigationController
{
    UIViewController* parentViewController = self.parentViewController;

    while (parentViewController &&
           ![parentViewController isKindOfClass:[DDGNavigationController class]])
    {
        parentViewController = parentViewController.parentViewController;
    }

    return (DDGNavigationController*)parentViewController;
}

@end