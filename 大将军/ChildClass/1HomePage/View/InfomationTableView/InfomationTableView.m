//
//  InfomationTableView.m
//  大将军
//
//  Created by 石燚 on 16/7/8.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "InfomationTableView.h"
#import "InfoTableViewCell.h"

@interface InfomationTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *infoTableView;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation InfomationTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    [self addSubview:self.infoTableView];
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
    cell.backgroundColor = BACKGROUNDCOLOR;
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}


#pragma mark - getter
- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc]initWithFrame:self.bounds];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        
        _infoTableView.rowHeight = SCREEN_HEIGHT / 3;
        
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _infoTableView.backgroundColor = BACKGROUNDCOLOR;
        
        [_infoTableView registerClass:[InfoTableViewCell class] forCellReuseIdentifier:@"InfoCell"];
    }
    return _infoTableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"知识 · 15个关于狗狗的冷知识你知道几个？",@"知识 · 给你一台狗语翻译机",@"知识 · 狗狗的“耳语”你知道吗？",@"我家大狗，竟然自己养了一只小狗做宠物！",@"知识 · 狗狗太胖还是太瘦？如何判断狗狗体格是否正常？"];
    }
    return _titleArray;
}

@end










