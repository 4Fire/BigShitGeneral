//
//  InfoTableViewCell.m
//  大将军
//
//  Created by 石燚 on 16/7/19.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "InfoTableViewCell.h"

@implementation InfoTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self initUserInterface];
    // Configure the view for the selected state
}

- (void)initUserInterface {
    [self.contentView addSubview:self.TbackGround];
}

#pragma mark - getter
- (UIView *)TbackGround {
    if (!_TbackGround) {
        _TbackGround = [[UIView alloc]init];
        _TbackGround.backgroundColor = [UIColor whiteColor];
        _TbackGround.bounds = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT / 3) * 0.9);
        _TbackGround.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 3 / 2);
    }
    return _TbackGround;
}

@end
