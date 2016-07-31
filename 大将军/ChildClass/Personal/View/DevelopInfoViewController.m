//
//  DevelopInfoViewController.m
//  大将军
//
//  Created by apple on 16/7/31.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "DevelopInfoViewController.h"

@interface DevelopInfoViewController ()
@property (nonatomic, strong) UILabel *version;//@"版本信息"
@property (nonatomic, strong) UILabel *versionInfo;//具体版本号
@property (nonatomic, strong) UILabel *intro;//功能简介
@property (nonatomic, strong) UITextView *introInfo;//具体功能介绍
@property (nonatomic, strong) UILabel *developer;//开发人员
@property (nonatomic, strong) UILabel *developer1;
@property (nonatomic, strong) UILabel *developer2;
@property (nonatomic, strong) UILabel *developer3;
@property (nonatomic, strong) UILabel *thanks;//感谢
@property (nonatomic, strong) UITextView *thanksInfo;//具体感谢
@property (nonatomic, strong) UILabel *contactUS;//联系我们
@property (nonatomic, strong) UILabel *email;//邮箱
@property (nonatomic, strong) NSArray<UIColor *> *colors;
@end

@implementation DevelopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:self.version];
    [self.view addSubview:self.versionInfo];
    [self.view addSubview:self.intro];
    [self.view addSubview:self.introInfo];
    [self.view addSubview:self.developer];
    [self.view addSubview:self.developer1];
    [self.view addSubview:self.developer2];
    [self.view addSubview:self.developer3];
    [self.view addSubview:self.thanks];
    [self.view addSubview:self.thanksInfo];
    [self.view addSubview:self.contactUS];
    [self.view addSubview:self.email];
}

#pragma mark - Methods
- (UILabel *)createLableWithText:(NSString *)text Bounds:(CGRect)bounds Center:(CGPoint)center colorful:(BOOL)colorful {
    UILabel *lab = [[UILabel alloc] init];
    lab.bounds = bounds;
    lab.center = center;
    lab.textAlignment = NSTextAlignmentCenter;
    if (colorful) {
        lab.font = [UIFont systemFontOfSize:20];
        lab.text = [NSString stringWithFormat:@"***** %@ *****", text];
        lab.textColor = self.colors[arc4random() % 7];
    }else {
        lab.text = text;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:16];
    }
    
    return lab;
}

#pragma mark - Getter

- (NSArray<UIColor *> *)colors {
    return @[COLOR(247, 68, 97), COLOR(147, 224, 254), COLOR(255, 95, 73), COLOR(236, 1, 18), COLOR(177, 153, 185), COLOR(140, 221, 73), COLOR(172, 237, 239)];
}

- (UILabel *)version {
    if (!_version) {
        _version = [self createLableWithText:@"版本信息" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.1) colorful:YES];
    }
    return _version;
}

- (UILabel *)versionInfo {
    if (!_versionInfo) {
        _versionInfo = [self createLableWithText:@"大将军刚刚出生,只是1.0.0啦" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetMaxY(self.version.frame) + SCREEN_WIDTH * 0.05) colorful:NO];
    }
    return _versionInfo;
}


@end
