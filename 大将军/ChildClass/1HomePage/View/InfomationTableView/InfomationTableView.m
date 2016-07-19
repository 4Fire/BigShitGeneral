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
    
    return cell;
}


#pragma mark - getter
- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc]initWithFrame:self.bounds];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        
        _infoTableView.rowHeight = SCREEN_HEIGHT / 3;
        
        [_infoTableView registerClass:[InfoTableViewCell class] forCellReuseIdentifier:@"InfoCell"];
    }
    return _infoTableView;
}


@end











