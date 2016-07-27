//
//  DoggyInfoTableViewCell.m
//  大将军
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "DoggyInfoTableViewCell.h"

#define CELL_W self.bounds.size.width
#define CELL_H self.bounds.size.height

@interface DoggyInfoTableViewCell ()
@property (nonatomic, strong) UIView *lineView;
@end

@implementation DoggyInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeUserInterface];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)initializeUserInterface {
    self.layer.cornerRadius = SCREEN_HEIGHT * 0.025 * 0.5;
    self.layer.masksToBounds = YES;
//    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self addSubview:self.titleLab];
    [self addSubview:self.lineView];
    [self addSubview:self.imageV];
    [self addSubview:self.infoLab];
    [self addSubview:self.dateLab];
}

#pragma mark - Getter 
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.frame = CGRectMake(SCREEN_HEIGHT * 0.03, 0, SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.07);
        _titleLab.font = [UIFont boldSystemFontOfSize:20];
        _titleLab.textColor = BACKGROUNDCOLOR;
//        _titleLab.backgroundColor = [UIColor orangeColor];
    }
    return _titleLab;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.95, 1);
        _lineView.center = CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetMaxY(self.titleLab.frame) + 0.005);
        _lineView.backgroundColor = BACKGROUNDCOLOR;
    }
    return _lineView;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.1, SCREEN_WIDTH * 0.1);
        _imageV.center = CGPointMake(SCREEN_WIDTH * 0.1, SCREEN_HEIGHT * 0.1 + CGRectGetMaxY(self.lineView.frame) * 0.5);
        _imageV.layer.cornerRadius = CGRectGetHeight(_imageV.bounds) * 0.5;
        _imageV.layer.masksToBounds = YES;
//        _imageV.backgroundColor = [UIColor orangeColor];
    }
    return _imageV;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.04)];
        _infoLab.center = CGPointMake(SCREEN_WIDTH * 0.5 + CGRectGetMaxX(self.imageV.frame) * 0.5, SCREEN_HEIGHT * 0.1 );
        _infoLab.font = [UIFont systemFontOfSize:17];
        _infoLab.textColor = BACKGROUNDCOLOR;
//        _infoLab.backgroundColor = [UIColor orangeColor];
    }
    return _infoLab;
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] init];
        _dateLab.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.06);
        _dateLab.center = CGPointMake(SCREEN_WIDTH * 0.5 + CGRectGetMaxX(self.imageV.frame) * 0.5, CGRectGetMaxY(self.infoLab.frame) + SCREEN_HEIGHT * 0.04);
        _dateLab.font = [UIFont boldSystemFontOfSize:20];
        _dateLab.textColor = BACKGROUNDCOLOR;
        _dateLab.adjustsFontSizeToFitWidth = YES;
//        _dateLab.backgroundColor = [UIColor grayColor];
    }
    return _dateLab;
}
@end
