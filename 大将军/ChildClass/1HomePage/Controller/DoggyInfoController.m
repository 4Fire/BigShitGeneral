//
//  DoggyInfoController.m
//  大将军
//
//  Created by 石燚 on 16/7/26.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "DoggyInfoController.h"
#import "DoggyInfoTableViewCell.h"

@interface DoggyInfoController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UIImageView *dogIcon;
@property (nonatomic, strong) UILabel *dogName;
@property (nonatomic, strong) UIImageView *nameImage;
@property (nonatomic, strong) UILabel *dogSex;
@property (nonatomic, strong) UIImageView *sexImage;
@property (nonatomic, strong) UILabel *dogAge;
@property (nonatomic, strong) UIImageView *ageImage;
@property (nonatomic, strong) UILabel *dogVariety;
@property (nonatomic, strong) UIImageView *varietyImage;
@property (nonatomic, strong) NSArray<NSString *> *titleArr;
@property (nonatomic, strong) NSArray<NSString *> *imageNameArr;
@property (nonatomic, strong) NSArray<NSString *> *infoArr;
@property (nonatomic, strong) NSArray<NSString *> *dateArr;

@property (nonatomic, strong) NSString *ininsecticideStr;//体内驱虫
@property (nonatomic, strong) NSString *outinsecticideStr;//体外驱虫
@property (nonatomic, strong) NSString *ppvStr;//细小
@property (nonatomic, strong) NSString *distemperStr;//犬瘟热
@property (nonatomic, strong) NSString *coronavirusStr;//冠状
@property (nonatomic, strong) NSString *rabiesStr;//狂犬病
@property (nonatomic, strong) NSString *toxoplasmaStr;//弓形虫
@end

static NSString *cellID = @"DoggyInfoCell";
static NSString *headerId = @"DoggyInfoHeader";

@implementation DoggyInfoController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = BACKGROUNDCOLOR;
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initializeUserInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    [self.headView addSubview:self.titleImage];
    [self.titleImage addSubview:self.dogIcon];
    [self.headView addSubview:self.nameImage];
    [self.headView addSubview:self.dogName];
    [self.headView addSubview:self.dogSex];
    [self.headView addSubview:self.sexImage];
    [self.headView addSubview:self.dogAge];
    [self.headView addSubview:self.ageImage];
    [self.headView addSubview:self.dogVariety];
    [self.headView addSubview:self.varietyImage];
}

- (void)initializeDataSource {
//    [Record fetchLastRecordToSQLiterWithContext:[Context context] Dog:_dog];
}

#pragma mark - PrivateMathod
- (UIImageView *)createImageViewWithCenter:(CGPoint)center ImageName:(NSString *)imageName {
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    view.bounds = CGRectMake(0, 0, CGRectGetWidth(self.headView.bounds) * 0.1, CGRectGetWidth(self.headView.bounds) * 0.1);
    view.center = center;
    return view;
}

- (UILabel *)createLabelWithCenter:(CGPoint)center {
    UILabel *lab = [[UILabel alloc] init];
    lab.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, 44);
    lab.center = center;
    lab.textColor = BACKGROUNDCOLOR;
    lab.font = [UIFont boldSystemFontOfSize:20];
    lab.adjustsFontSizeToFitWidth = YES;
    return lab;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoggyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.titleLab.text = self.titleArr[indexPath.section];
    cell.imageV.image = [UIImage imageNamed:self.imageNameArr[indexPath.section]];
    cell.infoLab.text = self.infoArr[indexPath.section];
    cell.dateLab.text = self.dateArr[indexPath.section];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.03)];
//    view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    return view;
}

// 返回组头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_WIDTH * 0.03;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT * 0.2;
}

#pragma mark - setter
- (void)setDog:(Dog *)dog {
    _dog = dog;
    self.dogIcon.image = [UIImage imageWithData:_dog.iconImage];
    self.dogName.text = _dog.name;
    self.dogSex.text = _dog.sex.integerValue == 0 ? @"人家是妹妹啦~(@^_^@)~" : @"人家可是个男孩子哎(*≧▽≦*)";
    self.dogVariety.text = [NSString stringWithFormat:@"我来自%@星球", _dog.variety];
    self.dogAge.text = [NSString stringWithFormat:@"%@我破壳而出",_dog.birthday];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"YYYY年MM月dd日";
    
    NSDate *date1 = [Record fetchIninsecticideRecordToSQLiterWithContext:[Context context] Dog:_dog].date;
    NSDate *date2 = [Record fetchOutinsecticideRecordToSQLiterWithContext:[Context context] Dog:_dog].date;
    NSDate *date3 = [Record fetchPPVRecordToSQLiterWithContext:[Context context] Dog:_dog ].date;
    NSDate *date4 = [Record fetchDistemperRecordToSQLiterWithContext:[Context context] Dog:_dog].date;
    NSDate *date5 = [Record fetchCoronavirusRecordToSQLiterWithContext:[Context context] Dog:_dog].date;
    NSDate *date6 = [Record fetchRabiesRecordToSQLiterWithContext:[Context context] Dog:_dog].date;
    NSDate *date7 = [Record fetchToxoplasmaRecordToSQLiterWithContext:[Context context] Dog:_dog].date;
    
    _ininsecticideStr = date1 == nil ? @"暂时没有做过体内驱虫!" : [format stringFromDate:date1];
    _outinsecticideStr = date2 == nil ? @"暂时没有做过体外驱虫!" : [format stringFromDate:date2];
    _ppvStr = date3 == nil ? @"暂时还未做过细小病毒免疫!" : [format stringFromDate:date3];
    _distemperStr = date4 == nil ? @"暂时还未做过犬瘟热病毒免疫!" : [format stringFromDate:date4];
    _coronavirusStr = date5 == nil ? @"暂时还未做过冠状病毒免疫!" : [format stringFromDate:date5];
    _rabiesStr = date6 == nil ? @"暂时还未做过狂犬病病毒免疫!" : [format stringFromDate:date6];
    _toxoplasmaStr = date7 == nil ? @"暂时还未做过弓形虫病毒免疫!" : [format stringFromDate:date7];
}


#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 110)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.rowHeight = SCREEN_HEIGHT * 0.2;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.userInteractionEnabled = NO;
        _tableView.allowsSelection = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
        //注册原型cell
        [_tableView registerClass:[DoggyInfoTableViewCell class] forCellReuseIdentifier:cellID];
        //注册header
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerId];
    }
    return _tableView;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.6)];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

- (UIImageView *)titleImage {
    if (!_titleImage) {
        _titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景.jpeg"]];
        _titleImage.frame = CGRectMake(0, 0, self.headView.bounds.size.width, CGRectGetHeight(self.headView.bounds) * 0.4);
    }
    return _titleImage;
}

- (UIImageView *)dogIcon {
    if (!_dogIcon) {
        _dogIcon = [[UIImageView alloc] initWithImage:[UIImage imageWithData:_dog.iconImage]];
        _dogIcon.backgroundColor = [UIColor orangeColor];
        _dogIcon.bounds = CGRectMake(0, 0, CGRectGetHeight(self.titleImage.bounds) * 0.8, CGRectGetHeight(self.titleImage.bounds) * 0.8);
        _dogIcon.center = self.titleImage.center;
        _dogIcon.layer.cornerRadius = CGRectGetHeight(_dogIcon.bounds) * 0.5;
        _dogIcon.layer.masksToBounds = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:_dogIcon.bounds];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = COLOR(235, 232, 6).CGColor;
        shapeLayer.lineWidth = 10;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [_dogIcon.layer addSublayer:shapeLayer];
    }
    return _dogIcon;
}

- (UIImageView *)nameImage {
    if (!_nameImage) {
        _nameImage = [self createImageViewWithCenter:CGPointMake(CGRectGetWidth(self.headView.bounds) * 0.23, CGRectGetHeight(self.headView.bounds) * 0.47) ImageName:@"name.png"];
    }
    return _nameImage;
}

- (UILabel *)dogName {
    if (!_dogName) {
        _dogName = [self createLabelWithCenter:CGPointMake(CGRectGetWidth(self.headView.bounds) * 0.6, CGRectGetHeight(self.headView.bounds) * 0.47)];
    }
    return _dogName;
}

- (UILabel *)dogSex {
    if (!_dogSex) {
        _dogSex = [self createLabelWithCenter:CGPointMake(CGRectGetWidth(self.headView.bounds) * 0.6, CGRectGetHeight(self.headView.bounds) * 0.6)];
    }
    return _dogSex;
}

- (UIImageView *)sexImage {
    if (!_sexImage) {
        _sexImage = [self createImageViewWithCenter:CGPointMake(CGRectGetWidth(self.headView.bounds) * 0.23, CGRectGetHeight(self.headView.bounds) * 0.6) ImageName:@"sex2.png"];
    }
    return _sexImage;
}

- (UILabel *)dogVariety {
    if (!_dogVariety) {
        _dogVariety = [self createLabelWithCenter:CGPointMake(CGRectGetWidth(self.headView.bounds) * 0.6, CGRectGetHeight(self.headView.bounds) * 0.75)];
    }
    return _dogVariety;
}

- (UIImageView *)varietyImage {
    if (!_varietyImage) {
        _varietyImage = [self createImageViewWithCenter:CGPointMake(CGRectGetWidth(self.headView.bounds) * 0.23, CGRectGetHeight(self.headView.bounds) * 0.75) ImageName:@"variety.png"];
    }
    return _varietyImage;
}

- (UILabel *)dogAge {
    if (!_dogAge) {
        _dogAge = [self createLabelWithCenter:CGPointMake(CGRectGetWidth(self.headView.bounds) * 0.6, CGRectGetHeight(self.headView.bounds) * 0.9)];
    }
    return _dogAge;
}

- (UIImageView *)ageImage {
    if (!_ageImage) {
        _ageImage = [self createImageViewWithCenter:CGPointMake(CGRectGetWidth(self.headView.bounds) * 0.23, CGRectGetHeight(self.headView.bounds) * 0.9) ImageName:@"birthday.png"];
    }
    return _ageImage;
}

- (NSArray<NSString *> *)titleArr {
    return @[@"体内驱虫统计", @"体外驱虫统计", @"细小病毒免疫统计", @"犬瘟热病毒免疫统计", @"冠状病毒免疫统计", @"狂犬病免疫统计", @"弓形虫免疫统计"];
}

- (NSArray<NSString *> *)imageNameArr {
    return @[@"virus1", @"virus2", @"virus3", @"virus4", @"virus5", @"virus6", @"virus7"];
}

- (NSArray<NSString *> *)infoArr {
    return @[@"最近一次体内驱虫日期为:", @"最近一次体外驱虫日期为:", @"最近一次细小病毒免疫日期为:", @"最近一次犬瘟热病毒免疫日期为:", @"最近一次冠状病毒免疫日期为:", @"最近一次狂犬病免疫日期为:", @"最近一次弓形虫免疫日期为:"];
}

- (NSArray<NSString *> *)dateArr {
    return @[_ininsecticideStr, _outinsecticideStr, _ppvStr, _distemperStr, _coronavirusStr, _rabiesStr, _toxoplasmaStr];
}
@end
