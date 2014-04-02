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
#import "DDGEdgePanGestureRecognizer.h"
#import "UIView+DDGConvenienceAdditions.h"


@implementation DDGNavigationController
{
    DDGEdgePanGestureRecognizer* _edgePanGestureRecognizer;
    NSMutableArray* _viewControllers;

    UIView* _contentViewContainer;
    UIView* _frontContentViewContainer;

    CGRect _contentRect;
    CGRect _backContentOffsetRect;
    CGRect _frontContentOffsetRect;
}

static const CGFloat DefaultContentParallaxFactor = 0.25f;
static const CGFloat DefaultAnimationDuration = 0.3f;

static const CGFloat AnimationDurationAfterPanning = 0.1f;
static const CGFloat RequiredVelocityToPopViewController = 100.0f;

static const CGFloat FrontContentShadowRadius = 5.0f;
static const CGFloat FrontContentShadowOpacity = 0.3f;

//==================================================================================================
// Init and Dealloc
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

    _edgePanGestureRecognizer =
        [[DDGEdgePanGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(screenEdgePanAction:)];

    _edgePanGestureRecognizer.edges = UIRectEdgeLeft;

    [self.view addGestureRecognizer:_edgePanGestureRecognizer];

    _contentViewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight;

    _frontContentViewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _frontContentViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                         UIViewAutoresizingFlexibleHeight;

    _frontContentViewContainer.hidden = YES;

    _frontContentViewContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    _frontContentViewContainer.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _frontContentViewContainer.layer.shadowRadius = FrontContentShadowRadius;
    _frontContentViewContainer.layer.shadowOpacity = FrontContentShadowOpacity;

    [self.view addSubview:_contentViewContainer];
    [self.view addSubview:_frontContentViewContainer];

    UIViewController* topViewController = self.topViewController;

    if (topViewController)
    {
        [self addChildViewController:topViewController];
        [topViewController beginAppearanceTransition:YES animated:NO];

        [self setContentView:topViewController.view];

        [topViewController endAppearanceTransition];
        [topViewController didMoveToParentViewController:self];
    }
}

- (void)viewDidLayoutSubviews
{
    _contentRect = self.view.bounds;
    _backContentOffsetRect = CGRectOffset(_contentRect, -(_contentRect.size.width * _parallaxFactor), 0.0f);
    _frontContentOffsetRect = CGRectOffset(_contentRect, _contentRect.size.width, 0.0f);

    _edgePanGestureRecognizer.enabled = NO;
    _edgePanGestureRecognizer.enabled = YES;

    _frontContentViewContainer.layer.shadowPath = CGPathCreateWithRect(self.view.bounds, nil);
}

//==================================================================================================
// Pushing and Popping Stack Items
//==================================================================================================

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    NSParameterAssert(viewController);

    _edgePanGestureRecognizer.enabled = NO;

    [_viewControllers addObject:viewController];

    UIViewController* topViewController = self.topViewController;
    UIViewController* backViewController = self.backViewController;

    [self addChildViewController:topViewController];

    [backViewController beginAppearanceTransition:NO animated:animated];
    [topViewController beginAppearanceTransition:YES animated:animated];

    [self setFrontContentView:topViewController.view];

    void (^completion)() = ^
    {
        [backViewController.view removeFromSuperview];
        [backViewController endAppearanceTransition];

        [self setContentView:topViewController.view];

        [topViewController didMoveToParentViewController:self];
        [topViewController endAppearanceTransition];

        _edgePanGestureRecognizer.enabled = YES;
    };

    if (animated)
    {
        [self animateFrontToCenterWithDuration:_animationDuration
                    animateFromCurrentPosition:NO
                                    completion:completion];
    }
    else
    {
        completion();
    }
}

- (UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    UIViewController* backViewController = self.backViewController;
    NSAssert(backViewController, @"Tried to pop the last view controller from the stack.");
    return [[self popToViewController:backViewController animated:animated] lastObject];
}

- (NSArray*)popToRootViewControllerAnimated:(BOOL)animated
{
    if (_viewControllers.count == 0) return @[];
    return [self popToViewController:_viewControllers[0] animated:animated];
}

- (NSArray*)popToViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if (viewController == self.topViewController) return @[];

    NSParameterAssert(viewController);
    NSUInteger index = [_viewControllers indexOfObject:viewController];
    NSAssert(index != NSNotFound, @"Tried to pop to view controller which is not on the stack.");

    _edgePanGestureRecognizer.enabled = NO;

    NSUInteger nextIndex = index + 1;

    NSArray* poppedViewControllers = [_viewControllers subarrayWithRange:NSMakeRange(nextIndex, _viewControllers.count - nextIndex)];

    UIViewController* topViewController = self.topViewController;
    UIViewController* backViewController = _viewControllers[index];

    [backViewController beginAppearanceTransition:YES animated:animated];

    [self setFrontContentView:topViewController.view];
    [self setContentView:backViewController.view];

    for (UIViewController* poppedViewController in poppedViewControllers)
    {
        [poppedViewController willMoveToParentViewController:nil];
    }

    [topViewController beginAppearanceTransition:NO animated:animated];

    [_viewControllers removeObjectsInArray:poppedViewControllers];

    void (^completion)() = ^
    {
        for (UIViewController* poppedViewController in poppedViewControllers)
        {
            [poppedViewController removeFromParentViewController];
        }

        [topViewController endAppearanceTransition];
        [backViewController endAppearanceTransition];

        _edgePanGestureRecognizer.enabled = YES;
    };

    if (animated)
    {
        [self animateFrontToRightWithDuration:_animationDuration
                   animateFromCurrentPosition:NO
                                   completion:completion];
    }
    else
    {
        completion();
    }

    return poppedViewControllers;
}

//==================================================================================================
// Panning
//==================================================================================================

- (void)screenEdgePanAction:(id)sender
{
    NSAssert(self.view.window.bounds.size.width, @"Window should have a width greater than 0!");

    if (_viewControllers.count <= 1) return;

    CGPoint translation = [_edgePanGestureRecognizer translationInView:self.view];
    CGPoint velocity = [_edgePanGestureRecognizer velocityInView:self.view];

    CGFloat percentage = MIN(MAX(translation.x / self.view.bounds.size.width, 0.0f), 1.0f);

    switch (_edgePanGestureRecognizer.state)
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

        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            [self failedPan];
            break;

        default:break;
    }
}

- (void)startedPanning
{
    UIViewController* topViewController = self.topViewController;
    UIViewController* backViewController = self.backViewController;

    [topViewController willMoveToParentViewController:nil];

    [topViewController beginAppearanceTransition:NO animated:YES];
    [backViewController beginAppearanceTransition:YES animated:YES];

    [self setContentView:backViewController.view];
    [self setFrontContentView:topViewController.view];

    _contentViewContainer.frame = _backContentOffsetRect;
    _frontContentViewContainer.frame = _contentRect;

    _frontContentViewContainer.hidden = NO;
}

- (void)updatePanPercentage:(CGFloat)percentage
{
    CGFloat interpolatedContentX = _backContentOffsetRect.origin.x +
                                   ((_contentRect.origin.x - _backContentOffsetRect.origin.x) * percentage);

    CGFloat interpolatedFrontContentX = _contentRect.origin.x +
                                        ((_frontContentOffsetRect.origin.x - _contentRect.origin.x) * percentage);

    _contentViewContainer.frame = CGRectMake(interpolatedContentX,
                                             _contentRect.origin.y,
                                             _contentRect.size.width,
                                             _contentRect.size.height);

    _frontContentViewContainer.frame = CGRectMake(interpolatedFrontContentX,
                                                  _contentRect.origin.y,
                                                  _contentRect.size.width,
                                                  _contentRect.size.height);
}

- (void)endedPanWithPercentage:(CGFloat)percentage velocity:(CGFloat)velocity
{
    UIViewController* topViewController = self.topViewController;
    UIViewController* backViewController = self.backViewController;

    BOOL animatingFrontToRight = percentage >= 0.5f ||
                                 velocity >= RequiredVelocityToPopViewController;

    void (^completion)() = ^
    {
        if (animatingFrontToRight)
        {
            [topViewController.view removeFromSuperview];
            [topViewController didMoveToParentViewController:nil];
            [_viewControllers removeLastObject];
        }
        else
        {
            [backViewController.view removeFromSuperview];
            [self setContentView:topViewController.view];
        }

        [topViewController endAppearanceTransition];
        [backViewController endAppearanceTransition];
    };

    if (animatingFrontToRight)
    {
        [self animateFrontToRightWithDuration:AnimationDurationAfterPanning
                   animateFromCurrentPosition:YES
                                   completion:completion];
    }
    else
    {
        [topViewController beginAppearanceTransition:YES animated:YES];
        [backViewController beginAppearanceTransition:NO animated:YES];

        [self animateFrontToCenterWithDuration:AnimationDurationAfterPanning
                    animateFromCurrentPosition:YES
                                    completion:completion];
    }
}

- (void)failedPan
{
    UIViewController* topViewController = self.topViewController;
    UIViewController* backViewController = self.backViewController;

    [topViewController beginAppearanceTransition:YES animated:NO];
    [backViewController beginAppearanceTransition:NO animated:NO];

    _frontContentViewContainer.hidden = YES;
    _contentViewContainer.frame = _contentRect;

    [backViewController.view removeFromSuperview];
    [self setContentView:topViewController.view];

    [topViewController endAppearanceTransition];
    [backViewController endAppearanceTransition];
}

//==================================================================================================
// Helpers
//==================================================================================================

- (void)animateFrontToCenterWithDuration:(CGFloat)duration
              animateFromCurrentPosition:(BOOL)animateFromCurrentPosition
                              completion:(void (^)())completion
{
    if (!animateFromCurrentPosition)
    {
        _contentViewContainer.frame = _contentRect;
        _frontContentViewContainer.frame = _frontContentOffsetRect;
    }

    _frontContentViewContainer.hidden = NO;

    void (^animations)() = ^
    {
        _contentViewContainer.frame = _backContentOffsetRect;
        _frontContentViewContainer.frame = _contentRect;
    };

    void (^animationCompletion)(BOOL) = ^(BOOL finished)
    {
        _contentViewContainer.frame = _contentRect;
        _frontContentViewContainer.hidden = YES;

        completion();
    };

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:animations
                     completion:animationCompletion];
}

- (void)animateFrontToRightWithDuration:(CGFloat)duration
             animateFromCurrentPosition:(BOOL)animateFromCurrentPosition
                             completion:(void (^)())completion
{
    if (!animateFromCurrentPosition)
    {
        _contentViewContainer.frame = _backContentOffsetRect;
        _frontContentViewContainer.frame = _contentRect;
    }

    _frontContentViewContainer.hidden = NO;

    void (^animations)() = ^
    {
        _contentViewContainer.frame = _contentRect;
        _frontContentViewContainer.frame = _frontContentOffsetRect;
    };

    void (^animationCompletion)(BOOL) = ^(BOOL finished)
    {
        _frontContentViewContainer.hidden = YES;
        completion();
    };

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:animations
                     completion:animationCompletion];
}

- (void)setFrontContentView:(UIView*)view
{
    [_frontContentViewContainer removeAllSubviews];

    if (view)
    {
        view.frame = _frontContentViewContainer.bounds;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleHeight;

        [_frontContentViewContainer addSubview:view];
    }
}

- (void)setContentView:(UIView*)view
{
    [_contentViewContainer removeAllSubviews];

    if (view)
    {
        view.frame = _contentViewContainer.bounds;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleHeight;

        [_contentViewContainer addSubview:view];
    }
}

//==================================================================================================
// Controller Containment
//==================================================================================================

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

- (UIViewController*)visibleViewController
{
    return self.presentedViewController ? self.presentedViewController : self.topViewController;
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

- (UIGestureRecognizer*)interactivePopGestureRecognizer
{
    return _edgePanGestureRecognizer;
}

@end

@implementation UIViewController (DDGNavigationControllerAddition)

- (DDGNavigationController*)ddgNavigationController
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