// DDGScreenEdgePanGestureRecognizer.m
//
// Created by Till Hagger on 01/04/14.

#import "DDGScreenEdgePanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation DDGScreenEdgePanGestureRecognizer
{
    BOOL _didStartOnEdge;
}

static const CGFloat EdgeRadius = 30.0f;

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch* touch = [touches anyObject];
    UIWindow* window = touch.window;

    CGPoint touchLocation = [touch locationInView:nil];

    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft)
    {
        CGPoint tempTouchLocation = touchLocation;

        touchLocation.x = tempTouchLocation.y;
        touchLocation.y = window.bounds.size.width - tempTouchLocation.x;
    }
    else
    {

    }

    NSLog(@"TOUCH %f, %f", touchLocation.x, touchLocation.y);

    _didStartOnEdge = NO;

    if ((_edges & UIRectEdgeLeft) == UIRectEdgeLeft)
    {
        if (touchLocation.x <= EdgeRadius)
        {
            _didStartOnEdge = YES;
        }
    }

    if ((_edges & UIRectEdgeRight) == UIRectEdgeRight)
    {
        if (touchLocation.x >= window.bounds.size.width - EdgeRadius)
        {
            _didStartOnEdge = YES;
        }
    }

    if (_didStartOnEdge)
    {
        [super touchesBegan:touches withEvent:event];
    }
    else
    {
        for (UITouch* touch in touches)
        {
            [self ignoreTouch:touch forEvent:event];
        }
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (_didStartOnEdge)
    {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (_didStartOnEdge)
    {
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (_didStartOnEdge)
    {
        [super touchesEnded:touches withEvent:event];
    }
}

@end