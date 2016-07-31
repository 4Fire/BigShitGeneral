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
    //导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    //狗狗视图刷新
    [self.doggyCollection.collection reloadData];

    //分割线 透明
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //设置左边的个人中心按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"将军府" style:(UIBarButtonItemStyleDone) target:self action:@selector(didLeftBtn)];

}
//点击个人中心按钮
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

//初始化数据源
- (void)initUserDataSource {
   
}

//初始化界面
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
//点击日历的代理
- (void)didselectDate {
//    self.tabBarController.selectedIndex = 1;
}

//点击选择了哪只狗狗的代理
- (void)didselectDoggy:(Dog *)dog {
    self.doggyInfoController.dog = dog;
    [self.navigationController pushViewController:self.doggyInfoController animated:YES];
}

#pragma mark - getter
//日历视图
- (CalendarView *)calendar {
    if (!_calendar) {
        _calendar = [[CalendarView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT / 7)];
        _calendar.delegate = self;
    }
    return _calendar;
}

//- (UIBarButtonItem *)todayItem {
//    if (!_todayItem) {
//        _todayItem = [[UIBarButtonItem alloc]initWithTitle:@"今天" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnToday)];
//    }
//    return _todayItem;
//}

//狗狗collection
- (DoggyCollectionView *)doggyCollection {
    if (!_doggyCollection) {
        
        NSArray *test = [DoggyModel getAllDogsWithCurrentOwner];
        _doggyCollection = [[DoggyCollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.25, SCREEN_WIDTH, SCREEN_HEIGHT * 0.25) WithDoggyArray:test];
        _doggyCollection.delegate = self;
    }
    return _doggyCollection;
}

//信息的tableveiw
- (InfomationTableView *)infomationTable {
    if (!_infomationTable) {
        _infomationTable = [[InfomationTableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.5, SCREEN_WIDTH, SCREEN_HEIGHT / 2 - self.tabBarController.tabBar.bounds.size.height)];
        _infomationTable.backgroundColor = BACKGROUNDCOLOR;
        
    }
    return _infomationTable;
}

//主人
- (Owner *)owner {
    if (!_owner) {
        _owner = [DoggyModel getOwnerInfo];
    }
    return _owner;
}

//狗狗详细信息的页面
- (DoggyInfoController *)doggyInfoController {
    if (!_doggyInfoController) {
        _doggyInfoController = [[DoggyInfoController alloc]init];
    }
    return _doggyInfoController;
}

@end






