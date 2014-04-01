// DDGScreenEdgePanGestureRecognizer.h
//
// Created by Till Hagger on 01/04/14.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DDGScreenEdgePanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic) UIRectEdge edges;

@end