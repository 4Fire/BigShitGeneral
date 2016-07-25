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
@property (nonatomic, strong) UIButton *delateBtn;

@end

@implementation PersonDogsCell

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"H_HideDelete" object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) * 0.5;
        self.layer.masksToBounds = YES;
        [self addSubview:self.dogIcon];
        [self addSubview:self.nameLab];
        [self addGestureRecognizer:self.gesture];
        [self addSubview:self.delateBtn];
        self.delateBtn.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidDeleteButton:) name:@"H_HideDelete" object:nil];
        
    }
    return self;
}

- (void)setIsDeleted:(BOOL)isDeleted {
    _isDeleted = isDeleted;
    if (_isDeleted) {
        self.delateBtn.hidden = NO;
        self.delateBtn.alpha = 1.0;
        self.alpha = 0.5;
    } else {
        _delateBtn.hidden = YES;
        self.alpha = 1;
    }
}

-(void)hidDeleteButton:(NSNotification *)notfi{
    id obj = notfi.object;
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        NSInteger index = [obj[@"index"] integerValue];
        if (index != _rowIndex) {
            self.delateBtn.hidden = YES;
            self.alpha = 1;
            self.isDeleted = NO;
        }
    }
}

- (void)responseToGesture:(UILongPressGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.delateBtn.hidden = NO;
        self.delateBtn.alpha = 1.0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"H_HideDelete" object:@{@"index":@(_rowIndex)}];
        if (_delegate && [_delegate respondsToSelector:@selector(personDogsCellDidChangeStatusCell:)]) {
            [_delegate personDogsCellDidChangeStatusCell:self];
        }
    }];
}

- (void)delate {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"主人你不要我了吗" message:@"删除后汪星人将永远离开" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不不不,手抖按错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.isDeleted = NO;
    }];
    UIAlertAction *delate = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:self];
        if ([_delegate respondsToSelector:@selector(personDogsCellDeletecell:)]) {
            [_delegate personDogsCellDeletecell:self];
            self.isDeleted = YES;
        }
    }];
    [alertController addAction:cancel];
    [alertController addAction:delate];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
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

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height * 0.2);
        _nameLab.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
        _nameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLab;
}

- (UILongPressGestureRecognizer *)gesture {
    if (!_gesture) {
        _gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(responseToGesture:)];
        _gesture.minimumPressDuration = 1.f;
    }
    return _gesture;
}

- (UIButton *)delateBtn {
    if (!_delateBtn ) {
        _delateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delateBtn.frame = self.bounds;
        [_delateBtn setImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
        [_delateBtn addTarget:self action:@selector(delate) forControlEvents:UIControlEventTouchUpInside];
        _delateBtn.alpha = 1;
    }
    return _delateBtn;
}

@end
