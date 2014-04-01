// DDGTestViewController.m
//
// Created by Till Hagger on 01/04/14.

#import "DDGTestViewController.h"
#import "UIColor+DDGColorAdditions.h"
#import "DDGNavigationController.h"


@implementation DDGTestViewController
{
    UIButton* _button;
}

- (void)loadView
{
    [super loadView];

    //self.view.layer.borderColor = [UIColor randomColor].CGColor;
    //self.view.layer.borderWidth = 1.0f;
    self.view.backgroundColor = [UIColor randomColor];

    _button = [[UIButton alloc] init];
    [_button addTarget:self
                action:@selector(pushTheButtonAction)
      forControlEvents:UIControlEventTouchUpInside];

    [_button setTitle:@"PUSH THE BUTTON" forState:UIControlStateNormal];
    [_button sizeToFit];

    _button.center = self.view.center;
    _button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                               UIViewAutoresizingFlexibleRightMargin |
                               UIViewAutoresizingFlexibleBottomMargin |
                               UIViewAutoresizingFlexibleLeftMargin;

    [self.view addSubview:_button];
}

- (void)pushTheButtonAction
{
    DDGTestViewController* testViewController = [[DDGTestViewController alloc] init];
    [self.ddg_navigationController pushViewController:testViewController
                                             animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@ -- %@ -- %i", self, NSStringFromSelector(_cmd), animated);
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@ -- %@ -- %i", self, NSStringFromSelector(_cmd), animated);
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%@ -- %@ -- %i", self, NSStringFromSelector(_cmd), animated);
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"%@ -- %@ -- %i", self, NSStringFromSelector(_cmd), animated);
}

- (void)willMoveToParentViewController:(UIViewController*)parent
{
    NSLog(@"%@ -- %@ -- %@", self, NSStringFromSelector(_cmd), parent);
}

- (void)didMoveToParentViewController:(UIViewController*)parent
{
    NSLog(@"%@ -- %@ -- %@", self, NSStringFromSelector(_cmd), parent);
}


@end