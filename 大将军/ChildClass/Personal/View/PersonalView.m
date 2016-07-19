//
//  PersonalView.m
//  大将军
//
//  Created by 石燚 on 16/7/7.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "PersonalView.h"
#import "Context.h"
#import "Dog.h"
#import "Owner.h"
#import "PersonDogsCell.h"
#import "LoginViewController.h"

#define PERSONAL_WIDTH self.bounds.size.width
#define PERSONAL_HEIGHT self.bounds.size.height


@interface PersonalView ()<UICollectionViewDelegate,UICollectionViewDataSource>

//用户头像
@property (nonatomic, strong) UIImageView *userHeader;

//doggy头像
@property (nonatomic, strong) UICollectionView *collectionView;

//狗数量
@property (nonatomic, strong) NSArray<Dog *> *dogs;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) CAShapeLayer *timeLine;

@property (nonatomic, strong) NSArray<UIButton *> *btns;

@property (nonatomic, strong) UIButton *ownerSettingBtn;

@property (nonatomic, strong) UIButton *quitBtn;

@end


static NSString *PersonDogsCellID = @"PersonDogsCell";

@implementation PersonalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.backgroundColor = BACKGROUNDCOLOR;
    [self addSubview:self.userHeader];
    [self addSubview:self.collectionView];
    [self addSubview:self.scrollView];
    [self addSubview:self.lineView];
    [self.scrollView addSubview:self.ownerSettingBtn];
    [self.scrollView addSubview:self.quitBtn];
    [self.scrollView.layer addSublayer:self.timeLine];
//    [self animationOfBtns];
   }

//- (void)animationOfBtnsWhenClose {
//    self.quitBtn.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
//    self.ownerSettingBtn.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
//}
//
//- (void)animationOfBtns {
//    self.quitBtn.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
//    self.ownerSettingBtn.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self digui:0];
//    });
//}

//- (void)digui:(NSInteger)index {
//    if (index == self.btns.count) {
//        return;
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self digui:(index + 1)];
//        UIButton *button = self.btns[index];
//        [UIView animateWithDuration:1 animations:^{
//            CATransform3D trans = CATransform3DIdentity;
//            trans.m34 = - 1 / 500;
//            button.layer.transform = CATransform3DConcat(trans, CATransform3DIdentity);
//        }];
//    });
//}

- (void)quit {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ownerAccount"];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
}

- (UIButton *)getBtnwithColor:(UIColor *)color title:(NSString *)title center:(CGPoint)center left:(BOOL)isLeft {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = color;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.bounds = CGRectMake(0, 0, self.bounds.size.width * 0.6, self.bounds.size.height * 0.05);
    btn.center = center;
    btn.layer.cornerRadius = CGRectGetHeight(btn.bounds) * 0.5;
    btn.layer.masksToBounds = YES;
    
    btn.contentEdgeInsets = UIEdgeInsetsMake(CGRectGetHeight(btn.bounds) * 0.01, CGRectGetHeight(btn.bounds) * 0.5, CGRectGetHeight(btn.bounds) * 0.01, CGRectGetHeight(btn.bounds) * 0.5);
    
    UIBezierPath *bezierPath;
    if (isLeft) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(btn.bounds) * 0.21, CGRectGetHeight(btn.bounds)) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(CGRectGetHeight(btn.bounds) * 0.5, CGRectGetHeight(btn.bounds) * 0.5)];
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        btn.layer.anchorPoint = CGPointMake(0.21, 0.5);
        
    }else {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetWidth(btn.bounds) * 0.79, 0, CGRectGetWidth(btn.bounds) * 0.21, CGRectGetHeight(btn.bounds)) byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(CGRectGetHeight(btn.bounds) * 0.5, CGRectGetHeight(btn.bounds) * 0.5)];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.layer.anchorPoint = CGPointMake(0.79, 0.5);
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    [btn.layer addSublayer:shapeLayer];
    
    return btn;
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSManagedObjectContext *ctx = [Context context];
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"];
    Owner *owner = [Owner fetchOwnerToSQLiterWithContext:ctx Account:account];
     _dogs = [Dog fetchAllDogsFromSQLiterWithContext:ctx withOwner:owner];
    if (_dogs.count < 3) {
        self.collectionView.scrollEnabled = NO;
    }else {
        self.collectionView.scrollEnabled = YES;
    }

    return _dogs.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PersonDogsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PersonDogsCellID forIndexPath:indexPath];
    if (indexPath.item < _dogs.count) {
        cell.dogIcon.image = [UIImage imageWithData:_dogs[indexPath.item].iconImage];
    }else {
        cell.dogIcon.image = [UIImage imageNamed:@"addImage_default.png"];
    }
    return cell;
}

#pragma mark - getter
- (UIImageView *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 20, SCREEN_HEIGHT / 20, SCREEN_WIDTH / 4, SCREEN_WIDTH / 4)];
        
        _userHeader.layer.cornerRadius = CGRectGetWidth(_userHeader.bounds) * 0.5;
        _userHeader.layer.masksToBounds = YES;
        
        NSData *ownerIcon = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerIcon"];
        if (ownerIcon == nil) {
            _userHeader.image = [UIImage imageNamed:@"ownerMale.jpeg"];
        }
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_userHeader.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(CGRectGetWidth(_userHeader.bounds) * 0.5, CGRectGetWidth(_userHeader.bounds) * 0.5)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.strokeColor = COLOR(211, 219, 38).CGColor;;
        shapeLayer.lineWidth = 5;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [_userHeader.layer addSublayer:shapeLayer];
    }
    return _userHeader;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(PERSONAL_WIDTH * 0.21, PERSONAL_WIDTH * 0.21);
        layout.minimumInteritemSpacing = PERSONAL_WIDTH * 0.03;
        layout.sectionInset = UIEdgeInsetsMake(PERSONAL_WIDTH * 0.03, PERSONAL_WIDTH * 0.03, PERSONAL_WIDTH * 0.03, PERSONAL_WIDTH * 0.03);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, PERSONAL_HEIGHT * 0.2, PERSONAL_WIDTH, PERSONAL_HEIGHT * 0.13) collectionViewLayout:layout];
        _collectionView.backgroundColor = BACKGROUNDCOLOR;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册原型cell
        [_collectionView registerClass:[PersonDogsCell class] forCellWithReuseIdentifier:PersonDogsCellID];
    }
    return _collectionView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, self.bounds.size.height * 0.34, self.bounds.size.width, self.bounds.size.height * 0.64);
        _scrollView .backgroundColor = BACKGROUNDCOLOR;
    }
    return _scrollView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.bounds = CGRectMake(0, 0, self.bounds.size.width * 0.8, 1);
        _lineView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.36);
        _lineView.backgroundColor = COLOR(251, 202, 10);
    }
    return _lineView;
}

- (UIButton *)ownerSettingBtn {
    if (!_ownerSettingBtn) {
        _ownerSettingBtn = [self getBtnwithColor:MAIN_COLOR title:@"大将军内务府" center:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.1) left:YES];
//        _ownerSettingBtn.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    }
    return _ownerSettingBtn;
}

- (UIButton *)quitBtn {
    if (!_quitBtn) {
        _quitBtn = [self getBtnwithColor:COLOR(134, 160, 5) title:@"本将军想休息" center:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.2) left:NO];
//        _quitBtn.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        [_quitBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}

- (NSArray<UIButton *> *)btns {
    return @[self.ownerSettingBtn, self.quitBtn];
}

- (CAShapeLayer *)timeLine {
    if (_timeLine) {
        _timeLine = [CAShapeLayer layer];
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(self.scrollView.bounds.size.width * 0.5, self.scrollView.bounds.size.height * 0.05)];
        [bezierPath addLineToPoint:CGPointMake(self.scrollView.bounds.size.width * 0.5, self.scrollView.bounds.size.height * 0.85)];
//        [bezierPath addLineToPoint:CGPointMake(self.scrollView.bounds.size.width * 0.5, self.scrollView.bounds.size.height * 0.05)];
//        bezierPath.lineWidth = 5;
//        bezierPath.miterLimit = 2;
        _timeLine.path = bezierPath.CGPath;
        _timeLine.strokeColor = COLOR(89, 57, 42).CGColor;
        _timeLine.lineWidth = 5;
        _timeLine.lineDashPhase = 2;
    }
    return _timeLine;
}

@end












