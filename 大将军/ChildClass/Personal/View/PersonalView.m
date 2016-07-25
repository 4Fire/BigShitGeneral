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
#import "OwnerSettingController.h"
#import "AddDogViewController.h"
#import "DogInfoViewController.h"

#define PERSONAL_WIDTH self.bounds.size.width
#define PERSONAL_HEIGHT self.bounds.size.height

#define SCROLL_WIDTH self.scrollView.bounds.size.width
#define SCROLL_HEIGHT self.scrollView.bounds.size.height


@interface PersonalView ()<UICollectionViewDelegate,UICollectionViewDataSource,PersonDogsCellDelegate,DogInfoViewControllerDelegate>

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

@property (nonatomic, strong) UIButton *versionBtn;

@property (nonatomic, strong) UIButton *aboutUsBtn;

@property (nonatomic, strong) UILabel *welcomeLab;

@property (nonatomic, strong) NSArray<UIColor *> *colors;

@property (nonatomic, strong) NSMutableDictionary *statusInfo;

@property (nonatomic, strong) UIImageView *imageV1;
@property (nonatomic, strong) UIImageView *imageV2;
@property (nonatomic, strong) UIImageView *imageV3;


@end


static NSString *PersonDogsCellID = @"PersonDogsCell";

@implementation PersonalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.statusInfo = [NSMutableDictionary dictionary];
        self.userInteractionEnabled = YES;
        [self initUserInterface];
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ownerSetting) name:@"ownerSetting" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delateDog:) name:@"delate" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)initUserInterface {
    self.backgroundColor = BACKGROUNDCOLOR;
    [self addSubview:self.userHeader];
    [self addSubview:self.collectionView];
    [self addSubview:self.scrollView];
    [self addSubview:self.lineView];
    [self.scrollView addSubview:self.ownerSettingBtn];
    [self.scrollView addSubview:self.versionBtn];
    [self.scrollView addSubview:self.aboutUsBtn];
    [self.scrollView addSubview:self.quitBtn];
    [self addSubview:self.welcomeLab];
    [self.scrollView addSubview:self.imageV1];
    [self.scrollView addSubview:self.imageV2];
    [self.scrollView addSubview:self.imageV3];
   }

- (void)ownerSetting {
    NSManagedObjectContext *ctx = [Context context];
    Owner *owner1 = [Owner fetchOwnerToSQLiterWithContext:ctx Account:[[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"]];
    self.userHeader.image = [UIImage imageWithData:owner1.iconImage];
    self.welcomeLab.text = [NSString stringWithFormat:@"欢迎%@大将军!", owner1.name];
}

- (void)animationOfBtns {
    self.quitBtn.layer.transform = CATransform3DMakeRotation(M_PI , 0, 1, 0);
    self.ownerSettingBtn.layer.transform = CATransform3DMakeRotation(M_PI , 0, 1, 0);
    self.versionBtn.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    self.aboutUsBtn.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self digui:0];
    });
}

- (void)digui:(NSInteger)index {
    if (index == self.btns.count) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self digui:(index + 1)];
        UIButton *button = self.btns[index];
        [UIView animateWithDuration:1 animations:^{
            CATransform3D trans = CATransform3DIdentity;
            trans.m34 = - 1 / 500;
            button.layer.transform = CATransform3DConcat(trans, CATransform3DIdentity);
        }];
    });
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark - Event
- (void)quit {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认退出铲屎大将军?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不不不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *delate = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ownerAccount"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }];
    [alertController addAction:cancel];
    [alertController addAction:delate];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)responseToOwnerSettingBtn {
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[OwnerSettingController alloc] init] animated:YES completion:nil];
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
    
//    NSManagedObjectContext *ctx = [Context context];
//    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"];
//    Owner *owner = [Owner fetchOwnerToSQLiterWithContext:ctx Account:account];
//     _dogs = [Dog fetchAllDogsFromSQLiterWithContext:ctx withOwner:owner];
    
    if (self.dogs.count < 3) {
        self.collectionView.scrollEnabled = NO;
    }else {
        self.collectionView.scrollEnabled = YES;
    }

    return self.dogs.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PersonDogsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PersonDogsCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.rowIndex = indexPath.row;
    cell.indexPath = indexPath;
    NSString *key = [NSString stringWithFormat:@"cell%ld", (long)indexPath.row];
    BOOL isDelete = [_statusInfo[key] boolValue];
    if (indexPath.item < _dogs.count) {
        cell.colorInt = _dogs[indexPath.row].neutering.integerValue;
        NSLog(@"!!!!%ld", cell.colorInt);
        cell.dogIcon.image = [UIImage imageWithData:_dogs[indexPath.row].iconImage];
        cell.nameLab.text = _dogs[indexPath.row].name;
        cell.isDeleted = isDelete;
        
    }else {
        cell.colorInt = 2;
        cell.dogIcon.image = [UIImage imageNamed:@"addImage_default.png"];
        cell.nameLab.hidden = YES;
        cell.isDeleted = isDelete;
        cell.gesture.enabled = NO;
    }

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dogs.count) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[AddDogViewController alloc] init] animated:YES completion:nil];
    }else {
        DogInfoViewController *vc = [[DogInfoViewController alloc] init];
        vc.delegate = self;
        vc.dog = self.dogs[indexPath.row];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
    }
}

#pragma mark ---- Delete
- (void)personDogsCellDeletecell:(PersonDogsCell *)cell{
    NSMutableArray *deleteArr = [self.dogs mutableCopy];
    [deleteArr removeObjectAtIndex:cell.indexPath.row];
    self.dogs = deleteArr;
    NSManagedObjectContext *ctx = [Context context] ;
    [Dog deleteDogFromSQLiterWithContext:ctx Name:cell.nameLab.text owner:[Owner fetchOwnerToSQLiterWithContext:ctx Account:[[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"]]];
    [self.statusInfo removeObjectForKey:[NSString stringWithFormat:@"cell%ld", cell.indexPath.row]];
    [self.collectionView deleteItemsAtIndexPaths:@[cell.indexPath]];
    [self.collectionView reloadData];
}

- (void)personDogsCellDidChangeStatusCell:(PersonDogsCell *)cell {
    NSIndexPath * indexPath = cell.indexPath;
    NSString *key = [NSString stringWithFormat:@"cell%ld", (long)indexPath.row];
    [_statusInfo setObject:@(YES) forKey:key];
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)dogInfoDidChanged {
    [self.collectionView reloadData];
}

#pragma mark - getter
- (UIImageView *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 20, SCREEN_HEIGHT / 20, SCREEN_WIDTH / 4, SCREEN_WIDTH / 4)];
        
        _userHeader.layer.cornerRadius = CGRectGetWidth(_userHeader.bounds) * 0.5;
        _userHeader.layer.masksToBounds = YES;
        
        NSString *ownerIcon = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerIcon"];
        if (!ownerIcon) {
            _userHeader.image = [UIImage imageNamed:@"ownerMale.jpeg"];
        }else {
            NSManagedObjectContext *ctx = [Context context];
            Owner *owner1 = [Owner fetchOwnerToSQLiterWithContext:ctx Account:[[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"]];
            _userHeader.image = [UIImage imageWithData:owner1.iconImage];
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
        _scrollView.backgroundColor = BACKGROUNDCOLOR;
//        _scrollView.layer.contents = (__bridge id)[UIImage imageNamed:@"狗2.jpeg"].CGImage;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(self.scrollView.bounds.size.width * 0.5, self.scrollView.bounds.size.height * 0.05)];
        [bezierPath addLineToPoint:CGPointMake(self.scrollView.bounds.size.width * 0.5, self.scrollView.bounds.size.height * 0.9)];
        CAShapeLayer *shapLayer = [CAShapeLayer layer];
        shapLayer.path = bezierPath.CGPath;
        shapLayer.strokeColor = [UIColor blackColor].CGColor;
        shapLayer.lineWidth = 5;
        self.quitBtn.layer.zPosition = -1;
        self.ownerSettingBtn.layer.zPosition = -1;
        self.versionBtn.layer.zPosition = -1;
        self.aboutUsBtn.layer.zPosition = -1;
        [_scrollView.layer addSublayer:shapLayer];
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
        _ownerSettingBtn = [self getBtnwithColor:MAIN_COLOR title:@"大将军内务府" center:CGPointMake(SCROLL_WIDTH * 0.5, SCROLL_HEIGHT * 0.1) left:YES];
        [_ownerSettingBtn addTarget:self action:@selector(responseToOwnerSettingBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ownerSettingBtn;
}

- (UIButton *)quitBtn {
    if (!_quitBtn) {
        _quitBtn = [self getBtnwithColor:COLOR(134, 160, 5) title:@"本将军想休息" center:CGPointMake(SCROLL_WIDTH * 0.5, SCROLL_HEIGHT * 0.75) left:NO];
        [_quitBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}

- (UIButton *)versionBtn {
    if (!_versionBtn) {
        _versionBtn = [self getBtnwithColor:COLOR(246, 87, 9) title:@"版本信息" center:CGPointMake(SCROLL_WIDTH * 0.5, SCROLL_HEIGHT * 0.3)  left:NO];
    }
    return _versionBtn;
}

- (UIButton *)aboutUsBtn {
    if (!_aboutUsBtn) {
        _aboutUsBtn = [self getBtnwithColor:COLOR(251, 212, 10) title:@"大将军开发组" center:CGPointMake(SCROLL_WIDTH * 0.5, SCROLL_HEIGHT * 0.5) left:YES];
    }
    return _aboutUsBtn;
}

- (NSArray<UIButton *> *)btns {
    return @[self.ownerSettingBtn, self.versionBtn, self.aboutUsBtn, self.quitBtn];
}

- (UILabel *)welcomeLab {
    if (!_welcomeLab) {
        _welcomeLab = [[UILabel alloc] init];
        _welcomeLab.bounds = CGRectMake(0, 0, SCROLL_WIDTH * 0.6, SCREEN_WIDTH * 0.08);
        _welcomeLab.center = CGPointMake(self.bounds.size.width * 0.65, self.bounds.size.height * 0.17);
//        _welcomeLab.backgroundColor = [UIColor orangeColor];
        _welcomeLab.textColor = self.colors[arc4random() % self.colors.count];
        _welcomeLab.adjustsFontSizeToFitWidth = YES;
        _welcomeLab.text = [NSString stringWithFormat:@"欢迎%@大将军!", [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"]];
    }
    return _welcomeLab;
}

- (NSArray<UIColor *> *)colors {
    return @[COLOR(247, 68, 97), COLOR(147, 224, 254), COLOR(255, 95, 73), COLOR(236, 1, 18), COLOR(177, 153, 185), COLOR(140, 221, 73), COLOR(172, 237, 239)];
}

- (NSArray<Dog *> *)dogs {
    NSManagedObjectContext *ctx = [Context context];
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"];
    Owner *owner = [Owner fetchOwnerToSQLiterWithContext:ctx Account:account];
    _dogs = [Dog fetchAllDogsFromSQLiterWithContext:ctx withOwner:owner];
    return _dogs;
}

- (UIImageView *)imageV1 {
    if (!_imageV1) {
        _imageV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sun.png"]];
        _imageV1.bounds = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds) * 0.7, CGRectGetWidth(self.scrollView.bounds) * 0.9);
        _imageV1.center = CGPointMake(CGRectGetMidX(self.scrollView.frame) * 0.55, CGRectGetHeight(self.scrollView.frame) * 0.27);
    }
    return _imageV1;
}

- (UIImageView *)imageV2 {
    if (!_imageV2) {
        _imageV2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clould2.png"]];
        _imageV2.bounds = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds) * 0.7, CGRectGetWidth(self.scrollView.bounds) * 0.9);
        _imageV2.center = CGPointMake(CGRectGetMidX(self.scrollView.frame) * 0.75, CGRectGetHeight(self.scrollView.frame) * 0.5);
    }
    return _imageV2;
}

- (UIImageView *)imageV3 {
    if (!_imageV3) {
        _imageV3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clould.png"]];
        _imageV3.bounds = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds) , CGRectGetWidth(self.scrollView.bounds));
        _imageV3.center = CGPointMake(CGRectGetMidX(self.scrollView.frame) * 1.1, CGRectGetHeight(self.scrollView.frame) * 1.1);
    }
    return _imageV3;
}

@end