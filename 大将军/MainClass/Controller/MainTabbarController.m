//
//  MainTabbarController.m
//  大将军
//
//  Created by 石燚 on 16/7/6.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "MainTabbarController.h"
#import "HomePageController.h"
#import "RecordController.h"
#import "CircleOfFriendsController.h"
#import "NearByController.h"
#import "PersonalView.h"
#import "Context.h"
#import "Owner.h"
#import "Dog.h"

@interface MainTabbarController ()


@property (nonatomic, strong) UITabBarController *tabbarController;
//4个页面视图(套navigation的)
@property (nonatomic, strong) UINavigationController *homePage;
@property (nonatomic, strong) UINavigationController *record;
@property (nonatomic, strong) UINavigationController *circleOfFriend;
@property (nonatomic, strong) UINavigationController *nearby;

//个人中心视图
@property (nonatomic, strong) PersonalView *drawView;
//跟人中心按钮(抽屉开关)
@property (nonatomic, strong) UIBarButtonItem *drawBtn;
//用于记录是否开关抽屉
@property (nonatomic, assign) BOOL isOpen;
//遮盖用的btn
@property (nonatomic, strong) UIButton *coverBtn;

//今天按钮
@property (nonatomic, strong) UIBarButtonItem *todayItem;

@end


static HomePageController *home = nil;
@implementation MainTabbarController

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isOpen = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserDataSource];
    [self initUserInterface];
    
}


- (void)initUserDataSource {
    
}

- (void)initUserInterface {
    [self.view addSubview:self.drawView];
    
    [self.view addSubview:self.tabbarController.view];
    [self addChildViewController:self.tabbarController];
    [self.tabbarController setViewControllers:@[self.homePage,self.record,self.nearby]];

    self.tabbarController.selectedIndex = 0;
    
    
}

- (void)drawOpenOrClose {
    if (_isOpen) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.drawView.transform = CGAffineTransformIdentity;
            self.tabbarController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self.coverBtn removeFromSuperview];
        }];
        
        _isOpen = NO;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.tabbarController.view addSubview:self.coverBtn];
            self.drawView.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH / 6 * 5, 0);
            self.tabbarController.view.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH / 6 * 5, 0);
        } completion:^(BOOL finished) {
//            [self.tabbarController.view addSubview:self.coverBtn];
        }];

        _isOpen = YES;
    }
}

//设置带导航的 UIViewController
- (UINavigationController *)setViewController:(UIViewController *)VC WithTitle:(NSString *)title TabBarTitle:(NSString *)tabBarTitle TabBarImage:(NSString *)tabBarImage SelectTabBarImage:(NSString *)selectTabBarImage {
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
    VC.navigationItem.title = title;
    VC.navigationController.tabBarItem.title = tabBarTitle;
    
    VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:tabBarImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectTabBarImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR(10, 10, 10),NSFontAttributeName:[UIFont boldSystemFontOfSize:10]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR(227, 56, 43),NSFontAttributeName:[UIFont boldSystemFontOfSize:10]} forState:UIControlStateSelected];
    
    if ([VC isKindOfClass:[HomePageController class]]) {
        VC.navigationItem.rightBarButtonItem = self.todayItem;
        home = (HomePageController *)VC;
        VC.navigationItem.leftBarButtonItem = self.drawBtn;
        
        VC.tabBarItem.image = [[UIImage imageNamed:tabBarImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectTabBarImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        NSLog(@"66666666666666666666666================%@",tabBarImage);
    } else {
        VC.navigationItem.leftBarButtonItem = self.drawBtn;
    
        
//        VC.tabBarItem.image = [[UIImage imageNamed:tabBarImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectTabBarImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    return nav;
}

#pragma mark - enents
- (void)returnToday {
    [home returnToday];
}

#pragma mark - getter
- (PersonalView *)drawView {
    if (!_drawView) {
        _drawView = [[PersonalView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH / 6 * 5, 0, SCREEN_WIDTH / 6 * 5, SCREEN_HEIGHT)];
    }
    return _drawView;
}

- (UIBarButtonItem *)drawBtn {
    if (!_drawBtn) {
        _drawBtn = [[UIBarButtonItem alloc]initWithTitle:@"将军府" style:(UIBarButtonItemStyleDone) target:self action:@selector(drawOpenOrClose)];
    }
    return _drawBtn;
}

- (UIBarButtonItem *)todayItem {
    if (!_todayItem) {
        _todayItem = [[UIBarButtonItem alloc]initWithTitle:@"今天" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnToday)];
    }
    return _todayItem;
}

- (UIButton *)coverBtn {
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _coverBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_coverBtn setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.2]];
        [_coverBtn addTarget:self action:@selector(drawOpenOrClose) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _coverBtn;
}

- (UINavigationController *)homePage {
    if (!_homePage) {
        _homePage = [self setViewController:[HomePageController new] WithTitle:@"汪汪汪" TabBarTitle:@"汪汪汪" TabBarImage:@"主业未选中" SelectTabBarImage:@"主页选中"];
    }
    return _homePage;
}

- (UINavigationController *)record {
    if (!_record) {
        _record = [self setViewController:[RecordController new] WithTitle:@"记录" TabBarTitle:@"记录" TabBarImage:@"记录未选中" SelectTabBarImage:@"记录选中"];
    }
    return _record;
}

- (UINavigationController *)nearby {
    if (!_nearby) {
        _nearby = [self setViewController:[NearByController new] WithTitle:@"遛狗" TabBarTitle:@"遛狗" TabBarImage:@"遛狗未选中" SelectTabBarImage:@"遛狗选中"];
    }
    return _nearby;
}

- (UINavigationController *)circleOfFriend {
    if (!_circleOfFriend) {
        _circleOfFriend = [self setViewController:[CircleOfFriendsController new] WithTitle:@"朋友圈" TabBarTitle:@"朋友圈" TabBarImage:nil SelectTabBarImage:nil];
    }
    return _circleOfFriend;
}

- (UITabBarController *)tabbarController {
    if (!_tabbarController) {
        _tabbarController = [UITabBarController new];
    }
    return _tabbarController;
}



@end
