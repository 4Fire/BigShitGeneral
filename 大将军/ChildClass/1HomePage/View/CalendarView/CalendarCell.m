//
//  CalendarCell.m
//  大将军
//
//  Created by 石燚 on 16/7/7.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.tesView addSubview:self.day];
        [self.tesView addSubview:self.month];
        [self.contentView addSubview:self.tesView];
    }
    return self;
}


- (UILabel *)day {
    if (!_day) {
        _day = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tesView.bounds.size.height / 2, self.tesView.bounds.size.width, self.tesView.bounds.size.height / 2)];
        _day.font = [UIFont boldSystemFontOfSize:14];
        _day.textAlignment = NSTextAlignmentCenter;
    }
    return _day;
}

- (UILabel *)month {
    if (!_month) {
        _month = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tesView.bounds.size.width, self.tesView.bounds.size.height / 2)];
        _month.font = [UIFont boldSystemFontOfSize:10];
        _month.textAlignment = NSTextAlignmentCenter;
    }
    return _month;
}

- (UIView *)tesView {
    if (!_tesView) {
        _tesView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10)];
        _tesView.backgroundColor = [UIColor orangeColor];
        _tesView.layer.cornerRadius = 8;
        _tesView.layer.masksToBounds = YES;
    }
    return _tesView;
}

@end
