//
//  HomePageController.m
//  大将军
//
//  Created by 石燚 on 16/7/6.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "HomePageController.h"
#import "CalendarView.h"
#import "DoggyCollectionView.h"
#import "InfomationTableView.h"
#import "Owner.h"
#import "Dog.h"
#import "Context.h"
#import "DoggyModel.h"
#import "DoggyInfoController.h"

@interface HomePageController ()<CalendarDelegate,doggyCollectionDelegate>

//日历
@property (nonatomic, strong) CalendarView *calendar;
//doggy
@property (nonatomic, strong) DoggyCollectionView *doggyCollection;
//信息
@property (nonatomic, strong) InfomationTableView *infomationTable;
//狗狗信息
@property (nonatomic, strong) DoggyInfoController *doggyInfoController;

//用户信息
@property (nonatomic, strong) Owner *owner;


//移动到今天
@property (nonatomic, strong) UIButton *todayBtn;
@property (nonatomic, strong) UIBarButtonItem *todayItem;

@end

@implementation HomePageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    
    [self.doggyCollection.collection reloadData];

    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"将军府" style:(UIBarButtonItemStyleDone) target:self action:@selector(didLeftBtn)];

}

- (void)didLeftBtn {
    if ([self.delegate respondsToSelector:@selector(clickLeftBtn)]) {
        [self.delegate clickLeftBtn];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserDataSource];
    [self initUserInterface];
    
}

- (void)initUserDataSource {
   
}


- (void)initUserInterface {
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    //添加日历
    [self.view addSubview:self.calendar];
    
    [self.navigationController.navigationBar setTintColor:COLOR(255, 255, 255)];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR(250, 205, 174),NSFontAttributeName:[UIFont boldSystemFontOfSize:28]}];
    
    //添加doggy
    [self.view addSubview:self.doggyCollection];
    
    //添加信息
    [self.view addSubview:self.infomationTable];



}

#pragma mark - method
//将今天的CELL放到中间
- (void)returnToday {
    [self.calendar scrollToCenter];
}

#pragma mark - delegate
- (void)didselectDate {
//    self.tabBarController.selectedIndex = 1;
}

- (void)didselectDoggy:(Dog *)dog {
    self.doggyInfoController.dog = dog;
    [self.navigationController pushViewController:self.doggyInfoController animated:YES];
}

#pragma mark - getter 
- (UIButton *)drawBtn {
    if (!_drawBtn) {
        _drawBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _drawBtn.backgroundColor = [UIColor blackColor];
    }
    return _drawBtn;
}

- (CalendarView *)calendar {
    if (!_calendar) {
        _calendar = [[CalendarView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT / 7)];
        _calendar.delegate = self;
    }
    return _calendar;
}

- (UIButton *)todayBtn {
    if (!_todayBtn) {
        _todayBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _todayBtn.bounds = CGRectMake(0, 0, SCREEN_WIDTH / 12, SCREEN_WIDTH / 12);
        [_todayBtn setImage:[UIImage imageNamed:@"today-red.png"] forState:(UIControlStateNormal)];
        [_todayBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _todayBtn.center = CGPointMake(SCREEN_WIDTH / 6 * 5, 20);
        [_todayBtn addTarget:self action:@selector(returnToday) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _todayBtn;
}

- (UIBarButtonItem *)todayItem {
    if (!_todayItem) {
        _todayItem = [[UIBarButtonItem alloc]initWithTitle:@"今天" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnToday)];
    }
    return _todayItem;
}

- (DoggyCollectionView *)doggyCollection {
    if (!_doggyCollection) {
        
        NSArray *test = [DoggyModel getAllDogsWithCurrentOwner];
        _doggyCollection = [[DoggyCollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.25, SCREEN_WIDTH, SCREEN_HEIGHT * 0.25) WithDoggyArray:test];
        _doggyCollection.delegate = self;
    }
    return _doggyCollection;
}

- (InfomationTableView *)infomationTable {
    if (!_infomationTable) {
        _infomationTable = [[InfomationTableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.5, SCREEN_WIDTH, SCREEN_HEIGHT / 2 - self.tabBarController.tabBar.bounds.size.height)];
        _infomationTable.backgroundColor = BACKGROUNDCOLOR;
        
    }
    return _infomationTable;
}

- (Owner *)owner {
    if (!_owner) {
        _owner = [DoggyModel getOwnerInfo];
    }
    return _owner;
}

- (DoggyInfoController *)doggyInfoController {
    if (!_doggyInfoController) {
        _doggyInfoController = [[DoggyInfoController alloc]init];
    }
    return _doggyInfoController;
}
#pragma mark - other
//imagewithColor
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end






