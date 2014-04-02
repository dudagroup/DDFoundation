// DDGTestViewController.m
//
// Created by Till Hagger on 01/04/14.

#import "DDGTestViewController.h"
#import "UIColor+DDGColorAdditions.h"
#import "DDGNavigationController.h"


@implementation DDGTestViewController
{
    UIButton* _pushButton;
    UIButton* _popButton;
}

- (void)loadView
{
    [super loadView];

    //self.view.layer.borderColor = [UIColor randomColor].CGColor;
    //self.view.layer.borderWidth = 1.0f;
    self.view.backgroundColor = [UIColor randomColor];

    _pushButton = [[UIButton alloc] init];
    [_pushButton addTarget:self
                    action:@selector(pushTheButtonAction)
          forControlEvents:UIControlEventTouchUpInside];

    [_pushButton setTitle:@"PUSH THE BUTTON" forState:UIControlStateNormal];
    [_pushButton sizeToFit];

    _pushButton.center = CGPointMake(self.view.center.x, self.view.center.y - 25.0f);
    _pushButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                                   UIViewAutoresizingFlexibleRightMargin |
                                   UIViewAutoresizingFlexibleBottomMargin |
                                   UIViewAutoresizingFlexibleLeftMargin;

    _popButton = [[UIButton alloc] init];
    [_popButton addTarget:self
                    action:@selector(popTheButtonAction)
          forControlEvents:UIControlEventTouchUpInside];

    [_popButton setTitle:@"POP THE BUTTON" forState:UIControlStateNormal];
    [_popButton sizeToFit];

    _popButton.center = CGPointMake(self.view.center.x, self.view.center.y + 25.0f);
    _popButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                                   UIViewAutoresizingFlexibleRightMargin |
                                   UIViewAutoresizingFlexibleBottomMargin |
                                   UIViewAutoresizingFlexibleLeftMargin;

    [self.view addSubview:_pushButton];
    [self.view addSubview:_popButton];
}

- (void)pushTheButtonAction
{
    DDGTestViewController* testViewController = [[DDGTestViewController alloc] init];
    [self.ddg_navigationController pushViewController:testViewController
                                             animated:YES];
}

- (void)popTheButtonAction
{
    [self.ddg_navigationController popToRootViewControllerAnimated:YES];
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