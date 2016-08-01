//
//  TableCellInfoController.m
//  大将军
//
//  Created by 石燚 on 16/8/1.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "TableCellInfoController.h"
#import "TableCellTableViewCell.h"

@interface TableCellInfoController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *bodyArr;
@property (nonatomic, strong) UILabel  *titleLab;
@end

static NSString *tableCellInfoCellID = @"tableCellInfoCell";
@implementation TableCellInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOLOR;
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    _infoDic = infoDic;
    NSLog(@"%@",_infoDic);
    _bodyArr = _infoDic[@"body"];
    [self initializeDataSource];
    [self initializeUserInterface];
    self.titleLab.text = _infoDic[@"title"];
}

- (void)initializeUserInterface {
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.titleLab;
}

- (void)initializeDataSource {
    
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bodyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellInfoCellID];
    [cell setLabText:_bodyArr[indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableCellTableViewCell *cell = (TableCellTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"%lf",[cell setLabText:_bodyArr[indexPath.row]]);
    return  [cell setLabText:_bodyArr[indexPath.row]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 110)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.allowsSelection = NO;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        //注册原型cell
        [_tableView registerClass:[TableCellTableViewCell class] forCellReuseIdentifier:tableCellInfoCellID];
    }
    return _tableView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.1)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont boldSystemFontOfSize:30];
        _titleLab.backgroundColor = BACKGROUNDCOLOR;
    }
    return _titleLab;
}

@end
