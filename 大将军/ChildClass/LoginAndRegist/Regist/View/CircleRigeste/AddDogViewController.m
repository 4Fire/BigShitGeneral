//
//  AddDogViewController.m
//  大将军
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "AddDogViewController.h"
#import "DogCollectionViewLayout.h"
#import "DogCollectionViewCell.h"
#import "NameView.h"
#import "SexView.h"
#import "VarietyView.h"
#import "NeuteringView.h"
#import "SureView.h"
#import "MainTabbarController.h"

#import <CoreData/CoreData.h>
#import "Dog.h"
#import "Owner.h"
#import "Context.h"

@interface AddDogViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate>
{
    NameView *_nameView;
}
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UICollectionView *detailViews;
@property (nonatomic, strong) SexView *sexView;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, copy) NSString *variety;
@property (nonatomic, strong) NSData *iconImage;
@property (nonatomic, strong) NSNumber *neutering;
@property (nonatomic, copy) NSDate *birthday;
@property (nonatomic, strong) UIButton *backBtn;

@end

static NSString *DogCollectionViewCellId = @"DogCollectionViewCell";

@implementation AddDogViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)initializeUserInterface {
    [self navigationAlligment];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.detailViews];
}

- (void)navigationAlligment {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage new] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.title = @"汪 来 了";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:COLOR(212, 20, 24), NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
}

- (void)responseToBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)responseToNext:(NSNotification *)notif {
    if ([notif.object isKindOfClass:[NameView class]]) {
        _iconImage = notif.userInfo[@"iconImage"];
        _name = notif.userInfo[@"name"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self collectionView:self.detailViews didSelectItemAtIndexPath:indexPath];
    }
    if ([notif.object isKindOfClass:[SexView class]]) {
        _birthday = notif.userInfo[@"birthday"];
        _sex = notif.userInfo[@"sex"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self collectionView:self.detailViews didSelectItemAtIndexPath:indexPath];
    }
    if ([notif.object isKindOfClass:[VarietyView class]]) {
        _variety = notif.userInfo[@"variety"];
         NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
        [self collectionView:self.detailViews didSelectItemAtIndexPath:indexPath];
    }
    if ([notif.object isKindOfClass:[NeuteringView class]]) {
        _neutering = notif.userInfo[@"neutering"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:3 inSection:0];
        [self collectionView:self.detailViews didSelectItemAtIndexPath:indexPath];
    }
    if ([notif.object isKindOfClass:[SureView class]]) {
        NSManagedObjectContext *ctx = [Context context];
        NSString *ownerAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"];
        Owner *owner = [Owner fetchOwnerToSQLiterWithContext:ctx Account:ownerAccount];
        [self dismissViewControllerAnimated:false completion:nil];
        [Dog insertDogToSQLiterWithContext:ctx Name:_name Icon:_iconImage Sex:_sex Variety:_variety Neutering:_neutering Birthday:_birthday Owner:owner];
         [[[UIApplication sharedApplication].delegate window] setRootViewController:[[MainTabbarController alloc] init]];
    }
}

#warning !!!!!!!
- (void)responseToSwipeGesture:(UISwipeGestureRecognizer *)gesture {
//    if (indexPath.item < 4) {
//        [self.detailViews setContentOffset:CGPointMake((indexPath.row + 1) * SCREEN_WIDTH * 3 / 4, collectionView.contentOffset.y) animated:YES];
//        [UIView animateWithDuration:0.2 animations:^{
//            self.backBtn.frame = CGRectMake((indexPath.row + 1) * SCREEN_WIDTH * 3 / 4, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64);
//        }];
//    } else {
//        [self.detailViews setContentOffset:CGPointMake((indexPath.row) * SCREEN_WIDTH * 3 / 4, collectionView.contentOffset.y) animated:YES];
//    }
    
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.detailViews.contentOffset.x > 0) {
            [self.detailViews setContentOffset:CGPointMake(self.detailViews.contentOffset.x - SCREEN_WIDTH * 3 / 4, self.detailViews.contentOffset.y)animated:YES];
            [UIView animateWithDuration:0.2 animations:^{
                self.backBtn.frame = CGRectMake(self.detailViews.contentOffset.x - SCREEN_WIDTH * 3 / 4, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64);
            }];
        }
        
        if (self.detailViews.contentOffset.x == 0 ) {
            self.backBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64);
            return;
        }
    }
}


#pragma mark - Keyboard
- (void)keyboardAction:(NSNotification *)notif {
    NSNumber *durationValue = notif.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
    [UIView animateWithDuration:durationValue.floatValue animations:^{
        [self.detailViews setFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
    }completion:^(BOOL finished) {
    }];
}

- (void)keyboarkHideAction:(NSNotification *)notification {
    NSNumber *durationValue = notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
    
    [UIView animateWithDuration:durationValue.floatValue animations:^{
        [self.detailViews setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }completion:^(BOOL finished) {
    }];
}


#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DogCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DogCollectionViewCellId forIndexPath:indexPath];
    if (indexPath.item == 0) {
        [cell.contentView addSubview:[[NameView alloc] initWithFrame:cell.bounds]];
    }
    if (indexPath.item == 1) {
        [cell.contentView addSubview:[[SexView alloc] initWithFrame:cell.bounds]];
    }
    if (indexPath.item == 2) {
        [cell.contentView addSubview:[[VarietyView alloc] initWithFrame:cell.bounds]];
    }
    if (indexPath.item == 3) {
        [cell.contentView addSubview:[[NeuteringView alloc] initWithFrame:cell.bounds]];
    }
    if (indexPath.item == 4) {
        [cell.contentView addSubview:[[SureView alloc] initWithFrame:cell.bounds]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < 4) {
        [self.detailViews setContentOffset:CGPointMake((indexPath.row + 1) * SCREEN_WIDTH * 3 / 4, collectionView.contentOffset.y) animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.backBtn.frame = CGRectMake((indexPath.row + 1) * SCREEN_WIDTH * 3 / 4, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64);
        }];
    } else {
        [self.detailViews setContentOffset:CGPointMake((indexPath.row) * SCREEN_WIDTH * 3 / 4, collectionView.contentOffset.y) animated:YES];
    }
}

#pragma mark - Getter
- (UICollectionView *)detailViews {
    if (!_detailViews) {
        _detailViews = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[DogCollectionViewLayout alloc] init]];
        _detailViews.delegate = self;
        _detailViews.dataSource = self;
        [_detailViews registerClass:[DogCollectionViewCell class] forCellWithReuseIdentifier:DogCollectionViewCellId];
        _detailViews.scrollEnabled = NO;
        _detailViews.allowsSelection = NO;
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64);
        _backBtn.backgroundColor = BACKGROUNDCOLOR;
        [_backBtn setTitle:@"返回上一页" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(responseToBack) forControlEvents:UIControlEventTouchUpInside];
        [_detailViews addSubview:_backBtn];
//        [self.view bringSubviewToFront:_backBtn];
        
        //添加手势
        UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] init];
        [gesture addTarget:self action:@selector(responseToSwipeGesture:)];
        [_detailViews addGestureRecognizer:gesture];
        
        //注册键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarkHideAction:) name:UIKeyboardWillHideNotification object:nil];

        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseToNext:) name:@"clickedNext" object:nil];
    }
    return _detailViews;
}
@end
