// DDGEdgePanGestureRecognizer.m
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

#import "DDGEdgePanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@implementation DDGEdgePanGestureRecognizer
{
    BOOL _didStartOnEdge;
}

static const CGFloat DefaultEdgeRadius = 20.0f;

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];

    if (self)
    {
        _edgeRadius = DefaultEdgeRadius;
    }

    return self;
}

- (NSUInteger)minimumNumberOfTouches
{
    return 1;
}

- (NSUInteger)maximumNumberOfTouches
{
    return 1;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (!_didStartOnEdge)
    {
        for (UITouch* touch in touches)
        {
            CGPoint touchLocation = [touch locationInView:self.view];

            if ((_edges & UIRectEdgeLeft) == UIRectEdgeLeft)
            {
                if (touchLocation.x <= _edgeRadius)
                {
                    _didStartOnEdge = YES;
                }
            }

            if ((_edges & UIRectEdgeRight) == UIRectEdgeRight)
            {
                if (touchLocation.x >= self.view.bounds.size.width - _edgeRadius)
                {
                    _didStartOnEdge = YES;
                }
            }

            if ((_edges & UIRectEdgeTop) == UIRectEdgeTop)
            {
                if (touchLocation.y <= _edgeRadius)
                {
                    _didStartOnEdge = YES;
                }
            }

            if ((_edges & UIRectEdgeBottom) == UIRectEdgeBottom)
            {
                if (touchLocation.y >= self.view.bounds.size.height - _edgeRadius)
                {
                    _didStartOnEdge = YES;
                }
            }

            if (_didStartOnEdge)
            {
                [super touchesBegan:touches withEvent:event];
            }
        }
    }
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesCancelled:touches withEvent:event];
    _didStartOnEdge = NO;
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesEnded:touches withEvent:event];
    _didStartOnEdge = NO;
}

@end