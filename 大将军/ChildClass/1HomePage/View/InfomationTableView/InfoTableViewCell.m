//
//  InfoTableViewCell.m
//  大将军
//
//  Created by 石燚 on 16/7/19.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "InfoTableViewCell.h"

@interface InfoTableViewCell ()


@end

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
    [self.TbackGround addSubview:self.titleLabel];
}

#pragma mark - getter
- (UIImageView *)TbackGround {
    if (!_TbackGround) {
        _TbackGround = [[UIImageView alloc]init];
        _TbackGround.backgroundColor = [UIColor whiteColor];
        _TbackGround.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.95, (SCREEN_HEIGHT / 3) * 0.9);
        _TbackGround.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 3 / 2);
        _TbackGround.userInteractionEnabled = YES;
    }
    return _TbackGround;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.TbackGround.frame) - (SCREEN_HEIGHT / 15), self.TbackGround.frame.size.width, SCREEN_HEIGHT / 15)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    }
    return _titleLabel;
}

@end
