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

@property (nonatomic, strong) UIButton *btn;
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
    [self.view addSubview:self.btn];
}

#pragma mark - Methods

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UILabel *)createLableWithText:(NSString *)text Bounds:(CGRect)bounds Center:(CGPoint)center colorful:(BOOL)colorful {
    UILabel *lab = [[UILabel alloc] init];
    lab.bounds = bounds;
    lab.center = center;
    lab.textAlignment = NSTextAlignmentCenter;
    if (colorful) {
        lab.font = [UIFont boldSystemFontOfSize:20];
        lab.text = [NSString stringWithFormat:@"******** %@ ********", text];
        lab.textColor = self.colors[arc4random() % 7];
    }else {
        lab.text = text;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:16];
        lab.adjustsFontSizeToFitWidth = YES;
    }
    
    return lab;
}

- (UITextView *)createTextViewWithBounds:(CGRect)bounds CenterY:(CGFloat)centerY Text:(NSString *)text {
    UITextView *textV = [[UITextView alloc] init];
    textV.bounds = bounds;
    textV.center = CGPointMake(SCREEN_WIDTH * 0.5, centerY);
    textV.userInteractionEnabled = NO;
    textV.font = [UIFont systemFontOfSize:16];
    textV.textColor = [UIColor whiteColor];
    textV.text = text;
    textV.backgroundColor = [UIColor clearColor];
    return textV;
}
#pragma mark - Getter

- (NSArray<UIColor *> *)colors {
    return @[COLOR(247, 68, 97), COLOR(147, 224, 254), COLOR(255, 95, 73), COLOR(236, 1, 18), COLOR(177, 153, 185), COLOR(140, 221, 73), COLOR(172, 237, 239)];
}

- (UILabel *)version {
    if (!_version) {
        _version = [self createLableWithText:@"版本信息" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.9, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.1) colorful:YES];
    }
    return _version;
}

- (UILabel *)versionInfo {
    if (!_versionInfo) {
        _versionInfo = [self createLableWithText:@"大将军刚刚出生,只是1.0.0啦" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetMaxY(self.version.frame) + SCREEN_WIDTH * 0.05) colorful:NO];
    }
    return _versionInfo;
}

- (UILabel *)intro {
    if (!_intro) {
        _intro = [self createLableWithText:@"功能简介" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.9, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetMaxY(self.versionInfo.frame) + SCREEN_WIDTH * 0.1) colorful:YES];
    }
    return _intro;
}

- (UITextView *)introInfo {
    if (!_introInfo) {
        _introInfo = [self createTextViewWithBounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.5) CenterY:(CGRectGetMaxY(self.intro.frame) + SCREEN_WIDTH * 0.25 ) Text:@"铲屎大将军是专为爱狗人士提供的一款记录类app，专业记录狗狗的各项免疫时间； 同时还有遛狗功能，可以记录每次遛狗的路线、距离、时间等；当然最大的优点就是可以添加多条狗狗满足当前铲屎官的需求，欢迎来到将军府，恭喜成为一名合格的铲屎官，您的狗狗很可爱哦n(*≧▽≦*)n"];
    }
    return _introInfo;
}

- (UILabel *)developer {
    if (!_developer) {
        _developer = [self createLableWithText:@"开发人员" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.9, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetMaxY(self.introInfo.frame) + SCREEN_WIDTH * 0.1) colorful:YES];
    }
    return _developer;
}

- (UILabel *)developer1 {
    if (!_developer1) {
        _developer1 = [self createLableWithText:@"石火火火火" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.3, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.25, (CGRectGetMaxY(self.developer.frame) + SCREEN_WIDTH * 0.05)) colorful:NO];
    }
    return _developer1;
}

- (UILabel *)developer2 {
    if (!_developer2) {
        _developer2 = [self createLableWithText:@"Summer❤️" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.3, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.55, (CGRectGetMaxY(self.developer.frame) + SCREEN_WIDTH * 0.05)) colorful:NO];
    }
    return _developer2;
}

- (UILabel *)developer3 {
    if (!_developer3) {
        _developer3 = [self createLableWithText:@"正经羊" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.3, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.8, (CGRectGetMaxY(self.developer.frame) + SCREEN_WIDTH * 0.05)) colorful:NO];
    }
    return _developer3;
}

- (UILabel *)thanks {
    if (!_thanks) {
        _thanks = [self createLableWithText:@"特别鸣谢" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.9, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetMaxY(self.developer3.frame) + SCREEN_WIDTH * 0.1) colorful:YES];
    }
    return _thanks;
}

- (UITextView *)thanksInfo {
    if (!_thanksInfo) {
        _thanksInfo = [self createTextViewWithBounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.25) CenterY:CGRectGetMaxY(self.thanks.frame) + SCREEN_WIDTH * 0.15 Text:@"首先感谢为铲屎大将军提供帮助和建议的所有朋友们，特别感谢刀哥！其次感谢您的支持，大将军还年轻，我们会越来越好！"];
    }
    return _thanksInfo;
}

- (UILabel *)contactUS {
    if (!_contactUS) {
        _contactUS = [self createLableWithText:@"联系我们" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.9, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetMaxY(self.thanksInfo.frame) + SCREEN_WIDTH * 0.1) colorful:YES];
    }
    return _contactUS;
}

- (UILabel *)email {
    if (!_email) {
        _email = [self createLableWithText:@"shitimperator@163.com" Bounds:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.05) Center:CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetMaxY(self.contactUS.frame) + SCREEN_WIDTH * 0.05) colorful:NO];
    }
    return _email;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(SCREEN_WIDTH * 0.9, SCREEN_WIDTH * 0.05, SCREEN_WIDTH * 0.1, SCREEN_WIDTH * 0.1);
        [_btn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    };
    return _btn;
}
@end
