// DDCollectable.h
//
// Created by Till Hagger on 20/12/13.
// Copyright (c) 2013 DU DA. All rights reserved.

#import "DDDebugOverlay.h"


// Can't use [[UIApplication sharedApplication] statusBarFrame] because it returns a
// bigger frame when in call-in mode.
static const CGFloat StatusBarHeight = 20.0f;

@interface DDOverlayWindow : UIWindow

@property (nonatomic, getter=isWindowActive) BOOL windowActive;

@end

@interface DDDebugOverlayController : UIViewController

@property (nonatomic, getter=isOverlayHidden) BOOL overlayHidden;

- (void)addDebugModuleController:(UIViewController<DDDebugModuleController>*)debugModuleController;

@end

@implementation DDDebugOverlayController
{
    UIView* _statusBarOverlay;
    UIScrollView* _moduleContainer;

    NSMutableArray* _modules;
    NSMutableArray* _separatorViews;
}

static void* PreferredModuleHeightContext = &PreferredModuleHeightContext;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.wantsFullScreenLayout = YES;

        if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }

        _modules = [[NSMutableArray alloc] init];
        _separatorViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    _statusBarOverlay = [[UIView alloc] init];
    _statusBarOverlay.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7f];
    _statusBarOverlay.frame = CGRectMake(0, 0, 0, StatusBarHeight);

    UILabel* appNameLabel = [[UILabel alloc] init];

    NSString* applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString* applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    appNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                                     applicationName,
                                                     applicationVersion];

    appNameLabel.backgroundColor = [UIColor clearColor];
    appNameLabel.textColor = [UIColor whiteColor];
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.font = [UIFont boldSystemFontOfSize:12.0f];

    appNameLabel.frame = _statusBarOverlay.bounds;

    appNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight;

    UISwipeGestureRecognizer* swipeGestureRecognizer =
        [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(swipeGestureAction)];

    [_statusBarOverlay addGestureRecognizer:swipeGestureRecognizer];
    [_statusBarOverlay addSubview:appNameLabel];

    _moduleContainer = [[UIScrollView alloc] init];

    _moduleContainer.alwaysBounceVertical = YES;

    _moduleContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    _moduleContainer.hidden = YES;

    [self.view addSubview:_statusBarOverlay];
    [self.view addSubview:_moduleContainer];
}

- (void)swipeGestureAction
{
    self.overlayHidden = !self.overlayHidden;
}

- (void)setOverlayHidden:(BOOL)overlayHidden
{
    _overlayHidden = overlayHidden;

    DDOverlayWindow* overlayWindow = (DDOverlayWindow*)self.view.window;
    overlayWindow.windowActive = !overlayHidden;

    _moduleContainer.hidden = overlayHidden;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    _statusBarOverlay.frame = CGRectMake(0.0f,
                                         0.0f,
                                         self.view.frame.size.width,
                                         StatusBarHeight);

    _moduleContainer.frame = CGRectMake(0.0f,
                                        StatusBarHeight,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height - StatusBarHeight);

    [self layoutModules];
}

- (UIView*)createSeparatorView
{
    UIView* separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = [UIColor whiteColor];

    return separatorView;
}

- (void)addDebugModuleController:(UIViewController<DDDebugModuleController>*)debugModuleController
{
    [_modules addObject:debugModuleController];

    [self addChildViewController:debugModuleController];

    UIView* separatorView = [self createSeparatorView];

    [_separatorViews addObject:separatorView];

    [_moduleContainer addSubview:debugModuleController.view];
    [_moduleContainer addSubview:separatorView];

    [debugModuleController addObserver:self
                            forKeyPath:@"preferredModuleHeight"
                               options:NSKeyValueObservingOptionNew
                               context:PreferredModuleHeightContext];

    [self.view setNeedsLayout];
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    if (context == PreferredModuleHeightContext)
    {
        [self.view setNeedsLayout];
    }
}

- (void)layoutModules
{
    __block CGFloat contentHeight = 0.0f;

    [_modules enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop)
    {
        UIViewController<DDDebugModuleController>* moduleController = obj;
        UIView* separatorView = _separatorViews[idx];

        moduleController.view.frame = CGRectMake(0,
                                                 contentHeight,
                                                 _moduleContainer.frame.size.width,
                                                 moduleController.preferredModuleHeight);

        contentHeight += moduleController.preferredModuleHeight;
        separatorView.frame = CGRectMake(0,
                                         contentHeight,
                                         _moduleContainer.frame.size.width,
                                         1.0f);
        contentHeight += 1.0f;
    }];

    _moduleContainer.contentSize = CGSizeMake(_moduleContainer.frame.size.width,
                                              contentHeight);
}

@end

@implementation DDOverlayWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _windowActive = NO;

        self.windowLevel = UIWindowLevelStatusBar + 1.0;
        self.hidden = NO;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    if (_windowActive)
    {
        return [super pointInside:point withEvent:event];
    }
    else
    {
        return CGRectContainsPoint([UIApplication sharedApplication].statusBarFrame, point);
    }
}

@end

@implementation DDDebugOverlay
{

}

static DDOverlayWindow* OverlayWindow = nil;
static DDDebugOverlayController* OverlayController = nil;

+ (void)enableOverlay
{
    if (OverlayWindow)
    {
        // Already enabled
        return;
    }

    OverlayController = [[DDDebugOverlayController alloc] init];
    OverlayWindow = [[DDOverlayWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    // Wrap in navigation controller for rotation support
    UINavigationController* navigationController =
        [[UINavigationController alloc] initWithRootViewController:OverlayController];

    [navigationController setNavigationBarHidden:YES];
    OverlayWindow.rootViewController = navigationController;
}

+ (void)addDebugModuleController:(UIViewController<DDDebugModuleController>*)debugModuleController
{
    NSAssert(OverlayWindow && OverlayController, @"Enable debug overlay first!");
    [OverlayController addDebugModuleController:debugModuleController];
}

@end
