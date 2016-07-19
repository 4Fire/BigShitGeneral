//
//  PersonDogsCell.m
//  大将军
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "PersonDogsCell.h"

@interface PersonDogsCell ()

@property (nonatomic, strong) NSArray<UIColor *> *colors;
@end

@implementation PersonDogsCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) * 0.5;
        self.layer.masksToBounds = YES;
        [self addSubview:self.dogIcon];
    }
    return self;
}


#pragma mark - Getter
- (UIImageView *)dogIcon {
    if (!_dogIcon) {
        _dogIcon = [[UIImageView alloc] initWithFrame:self.bounds];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_dogIcon.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetWidth(self.bounds) * 0.5)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.strokeColor = self.colors[arc4random() % self.colors.count].CGColor;;
        shapeLayer.lineWidth = 5;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [_dogIcon.layer addSublayer:shapeLayer];
//        _dogIcon.layer.masksToBounds = YES;
    }
    return _dogIcon;
}

- (NSArray<UIColor *> *)colors {
    return @[COLOR(247, 68, 97), COLOR(147, 224, 254), COLOR(255, 95, 73), COLOR(236, 1, 18), COLOR(177, 153, 185), COLOR(140, 221, 73), COLOR(172, 237, 239)];
}
@end
