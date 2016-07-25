//
//  DoggyCell.m
//  大将军
//
//  Created by 石燚 on 16/7/7.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "DoggyCell.h"

@implementation DoggyCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    
}

#pragma mark - getter
- (UIImageView *)doggyIcon {
    if (!_doggyIcon) {
        _doggyIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10)];
        _doggyIcon.layer.cornerRadius = (self.bounds.size.width - 10) / 2;
        _doggyIcon.layer.masksToBounds = YES;
        [self.contentView addSubview:_doggyIcon];
    }
    return _doggyIcon;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        [self.contentView addSubview:_coverView];
        [self.contentView bringSubviewToFront:_coverView];
    }
    return _coverView;
}



@end
