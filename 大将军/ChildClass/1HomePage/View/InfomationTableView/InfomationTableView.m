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

#pragma mark - delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(InfomationTableView:didSelectIndepathForCell:)]) {
        [self.delegate InfomationTableView:tableView didSelectIndepathForCell:indexPath];
    }
    
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
    cell.backgroundColor = BACKGROUNDCOLOR;
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.TbackGround.image = [UIImage imageNamed:[NSString stringWithFormat:@"cell%ld.jpeg",indexPath.row + 1]];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
        _titleArray = @[@"关于狗狗的16个冷知识",@"夏日养狗要注意!",@"狗语翻译机",@"狗狗的“耳语”",@"为啥狗狗老喜欢闻屁股呢?"];
    }
    return _titleArray;
}

@end










