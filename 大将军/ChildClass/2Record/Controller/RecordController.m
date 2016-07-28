//
//  RecordController.m
//  大将军
//
//  Created by 石燚 on 16/7/6.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "RecordController.h"
#import "TableRecord1Cell.h"
#import "TableHeader.h"
#import "Dog.h"
#import "DoggyModel.h"
#import "DoggyCell.h"

@interface RecordController ()<UITableViewDelegate,UITableViewDataSource,TableHeaderDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

//记录的table
@property (nonatomic, strong) UITableView *tableView;
//头部视图的日历
@property (nonatomic, strong) TableHeader *tableHeader;

@property (nonatomic, strong) NSArray *cellTitleArrayOfMale;
@property (nonatomic, strong) NSArray *cellTitleArrayOfFamale;

//上一月和下一月
@property (nonatomic, strong) UIButton *nextMonthBtn;
@property (nonatomic, strong) UIButton *lastMonthBtn;

//所有的狗
@property (nonatomic, strong) NSArray<Dog *> *dogs;

@property (nonatomic, strong) UICollectionView *collectionView;

//gou
@property (nonatomic, strong) Dog *dog;

//确定按钮
@property (nonatomic, strong) UIButton *sureBtn;

//记录用的
@property (nonatomic, strong) Record *record;
@property (nonatomic, strong) NSDictionary *recordDic;
//列表前的
@property (nonatomic, strong) NSMutableDictionary *tableDic;

@end


static NSInteger currentDog = 0;

@implementation RecordController


- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = BACKGROUNDCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //刷新数据源
    [self initUserDataSuource];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"将军府" style:(UIBarButtonItemStyleDone) target:self action:@selector(didLeftBtn)];
    
}

- (void)didLeftBtn {
    if ([self.delegate respondsToSelector:@selector(RecordClickLeftBtn)]) {
        [self.delegate RecordClickLeftBtn];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserDataSuource];
    [self initUserInterface];
    
}

//初始化数据源
- (void)initUserDataSuource {
    _dog = self.dogs[0];
    _record = [DoggyModel getRecordWithDoggyName:_dog date:[NSDate date]];
    if (_record) {
        _recordDic = [DoggyModel DictionartFromRecord:_record WithDog:_dog];
    }
    
    if (_dog.sex.integerValue == 0) {
        _tableDic = [@{@"体内驱虫":@NO,@"体外驱虫":@NO,@"细小病毒免疫":@NO,@"犬瘟热病毒免疫":@NO,@"冠状病毒免疫":@NO,@"狂犬病疫苗":@NO,@"弓形虫疫苗":@NO,@"怀孕":@NO,@"分娩":@NO,@"绝育":@NO} mutableCopy];
    } else {
        _tableDic = [@{@"体内驱虫":@NO,@"体外驱虫":@NO,@"细小病毒免疫":@NO,@"犬瘟热病毒免疫":@NO,@"冠状病毒免疫":@NO,@"狂犬病疫苗":@NO,@"弓形虫疫苗":@NO,@"绝育":@NO} mutableCopy];
    }
    
    
    [self.tableView reloadData];
}

//初始化界面
- (void)initUserInterface {
    [self.view addSubview:self.tableView];
    [self.navigationController.navigationBar addSubview:self.nextMonthBtn];
    [self.navigationController.navigationBar addSubview:self.lastMonthBtn];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY年MM月d日";
    self.navigationItem.title = [formatter stringFromDate:[NSDate date]];
    
    UIBarButtonItem *rigthBtn = [[UIBarButtonItem alloc]initWithTitle:@"今天" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickToday)];
    self.navigationItem.rightBarButtonItem = rigthBtn;
    
    self.tableView.tableFooterView = self.sureBtn;

}

#pragma mark - talbeViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dog.sex.integerValue == 0) {
        if (_dog.neutering.integerValue == 0) {
            return self.cellTitleArrayOfFamale.count;
        } else {
            return self.cellTitleArrayOfFamale.count - 3;
        }
    } else {
        if (_dog.neutering.integerValue == 0) {
            return self.cellTitleArrayOfMale.count;
        } else {
            return self.cellTitleArrayOfMale.count - 1;
        }
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    
    if (_dog.sex.integerValue == 0) {
        cell.textLabel.text = self.cellTitleArrayOfFamale[indexPath.row];
        UISwitch *cellSwitch = [[UISwitch alloc]init];
        [cellSwitch addTarget:self action:@selector(switchAction:) forControlEvents:(UIControlEventValueChanged)];
        cellSwitch.on = [self.tableDic[self.cellTitleArrayOfFamale[indexPath.row]] boolValue];
        cellSwitch.tag = 1000 + indexPath.row;
        cell.accessoryView = cellSwitch;
    } else {
        cell.textLabel.text = self.cellTitleArrayOfMale[indexPath.row];
        UISwitch *cellSwitch = [[UISwitch alloc]init];
        [cellSwitch addTarget:self action:@selector(switchAction:) forControlEvents:(UIControlEventValueChanged)];
        cellSwitch.on = [self.tableDic[self.cellTitleArrayOfFamale[indexPath.row]] boolValue];
        cellSwitch.tag = 1000 + indexPath.row;
        cell.accessoryView = cellSwitch;
    }
    
    return cell;
}

#pragma makr - CELLSWITCH
- (void)switchAction:(UISwitch *)sender {
    if (_dog.sex.integerValue == 0) {
        if (sender.isOn) {
            [self.tableDic setObject:@YES forKey:self.cellTitleArrayOfFamale[sender.tag - 1000]];
        } else {
            [self.tableDic setObject:@NO forKey:self.cellTitleArrayOfFamale[sender.tag - 1000]];
        }
    } else {
        if (sender.isOn) {
            [self.tableDic setObject:@YES forKey:self.cellTitleArrayOfMale[sender.tag - 1000]];
        } else {
            [self.tableDic setObject:@NO forKey:self.cellTitleArrayOfFamale[sender.tag - 1000]];
        }
    }
//    NSLog(@"%@",[self.tableDic[@"体内驱虫"] boolValue]);
    NSLog(@"%@",self.tableDic);
}

- (void)clickSureBtn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定添加记录吗?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不不不,手抖按错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *delate = [UIAlertAction actionWithTitle:@"确认添加" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        
        formatter.dateFormat = @"YYYY年MM月dd日";
        
        
        [DoggyModel insertRecordDogWithppv:_tableDic[@"细小病毒免疫"] distemper:_tableDic[@"犬瘟热病毒免疫"] coronavirus:_tableDic[@"冠状病毒免疫"] rabies:_tableDic[@"狂犬病疫苗"] toxoplasma:_tableDic[@"弓形虫疫苗"] ininsecticide:_tableDic[@"体内驱虫"] outinsecticide:_tableDic[@"体外驱虫"] pregnant:_tableDic[@"怀孕"] delivery:_tableDic[@"分娩"] neutering:_tableDic[@"绝育"] date:[formatter dateFromString:self.navigationItem.title] other:nil Dog:_dog];
        
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:delate];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_HEIGHT * 0.13;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3)];
    view.backgroundColor = [UIColor redColor];
    return self.collectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT / 10;
}

#pragma mark - tableHeaderDelegate 
- (void)TableHeader:(TableHeader *)tableHeader selectTime:(NSString *)time {
    self.navigationItem.title = time;
    if (_dog.sex.integerValue == 0) {
        _tableDic = [@{@"体内驱虫":@NO,@"体外驱虫":@NO,@"细小病毒免疫":@NO,@"犬瘟热病毒免疫":@NO,@"冠状病毒免疫":@NO,@"狂犬病疫苗":@NO,@"弓形虫疫苗":@NO,@"怀孕":@NO,@"分娩":@NO,@"绝育":@NO} mutableCopy];
    } else {
        _tableDic = [@{@"体内驱虫":@NO,@"体外驱虫":@NO,@"细小病毒免疫":@NO,@"犬瘟热病毒免疫":@NO,@"冠状病毒免疫":@NO,@"狂犬病疫苗":@NO,@"弓形虫疫苗":@NO,@"绝育":@NO} mutableCopy];
    }
    [self.tableView reloadData];
}

- (void)TableHeader:(TableHeader *)tableHeader changeHeight:(BOOL)change {
    if (change) {
        self.tableHeader.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 7 * 6 + 20);
    } else {
        self.tableHeader.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 7 * 5 + 20);
    }
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = self.tableHeader;
    [self.tableView endUpdates];
}

#pragma mark - nextMonthAndlastMonth
- (void)nextMonth {
    [self.tableHeader nextMonth];
}

- (void)lastMonth {
    [self.tableHeader lastMonth];
}

- (void)clickToday {
    [self.tableHeader today];
}

#pragma mark - getter
//table视图
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = BACKGROUNDCOLOR;

        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[TableRecord1Cell class] forCellReuseIdentifier:@"TableRecord1Cell"];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
        
        //隐藏滚动条
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.tableHeaderView = self.tableHeader;
        
        _tableView.bounces = NO;
    }
    return _tableView;
}

//上一月和下一月
- (UIButton *)nextMonthBtn {
    if (!_nextMonthBtn) {
        _nextMonthBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_nextMonthBtn setTitle:@"下一月" forState:(UIControlStateNormal)];
        _nextMonthBtn.frame = CGRectMake(SCREEN_WIDTH / 16 * 11, self.navigationController.navigationBar.bounds.size.height / 3, SCREEN_WIDTH / 7, self.navigationController.navigationBar.bounds.size.height / 2);
//        [_nextMonthBtn setBackgroundColor:[UIColor redColor]];
        _nextMonthBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_nextMonthBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_nextMonthBtn addTarget:self action:@selector(nextMonth) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nextMonthBtn;
}

- (UIButton *)lastMonthBtn {
    if (!_lastMonthBtn) {
        _lastMonthBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_lastMonthBtn setTitle:@"上一月" forState:(UIControlStateNormal)];
        _lastMonthBtn.frame = CGRectMake(SCREEN_WIDTH / 6, self.navigationController.navigationBar.bounds.size.height / 3, SCREEN_WIDTH / 7, self.navigationController.navigationBar.bounds.size.height / 2);
//        [_lastMonthBtn setBackgroundColor:[UIColor redColor]];
        [_lastMonthBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _lastMonthBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_lastMonthBtn addTarget:self action:@selector(lastMonth) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _lastMonthBtn;
}

//头部视图的日历
- (TableHeader *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[TableHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 7 * 6 + 20)];
        _tableHeader.backgroundColor = BACKGROUNDCOLOR;
        _tableHeader.tableHeaderDelegate = self;
    }
    
    return _tableHeader;
}

- (NSArray *)cellTitleArrayOfMale {
    if (!_cellTitleArrayOfMale) {
        _cellTitleArrayOfMale = @[@"体内驱虫",@"体外驱虫",@"细小病毒免疫",@"犬瘟热病毒免疫",@"冠状病毒免疫",@"狂犬病疫苗",@"弓形虫疫苗",@"绝育"];
    }
    return _cellTitleArrayOfMale;
}

- (NSArray *)cellTitleArrayOfFamale {
    if (!_cellTitleArrayOfFamale) {
        _cellTitleArrayOfFamale = @[@"体内驱虫",@"体外驱虫",@"细小病毒免疫",@"犬瘟热病毒免疫",@"冠状病毒免疫",@"狂犬病疫苗",@"弓形虫疫苗",@"怀孕",@"分娩",@"绝育"];
    }
    return _cellTitleArrayOfFamale;
}

- (NSArray<Dog *> *)dogs {
    return [DoggyModel getAllDogsWithCurrentOwner];
}

//- (NSMutableDictionary *)tableDic {
//    return _tableDic;
//}

//添加记录的按钮
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sureBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 10);
        [_sureBtn setTitle:@"确定添加记录" forState:(UIControlStateNormal)];
        _sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_sureBtn setBackgroundColor:BACKGROUNDCOLOR];
        _sureBtn.layer.cornerRadius = SCREEN_HEIGHT / 40;
        _sureBtn.layer.masksToBounds = YES;
        
        [_sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureBtn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH * 0.19, SCREEN_WIDTH * 0.19);
        layout.minimumInteritemSpacing = SCREEN_WIDTH * 0.03;
        layout.sectionInset = UIEdgeInsetsMake(SCREEN_WIDTH * 0.03, SCREEN_WIDTH * 0.03, SCREEN_WIDTH * 0.03, SCREEN_WIDTH * 0.03);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.13) collectionViewLayout:layout];
        _collectionView.backgroundColor = BACKGROUNDCOLOR;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册原型cell
        [_collectionView registerClass:[DoggyCell class] forCellWithReuseIdentifier:@"PersonDogsCelliii"];
    }
    return _collectionView;
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dogs.count < 3) {
        self.collectionView.scrollEnabled = NO;
    }else {
        self.collectionView.scrollEnabled = YES;
    }
    return self.dogs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DoggyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PersonDogsCelliii" forIndexPath:indexPath];
    
    cell.doggyIcon.image = [UIImage imageWithData:self.dogs[indexPath.row].iconImage];
    
    cell.layer.cornerRadius = SCREEN_WIDTH * 0.095;
    cell.layer.masksToBounds = YES;
    
    if (self.dogs[indexPath.row].sex.integerValue == 0) {
        cell.backgroundColor = COLOR(247, 68, 97);
    } else {
        cell.backgroundColor = COLOR(147, 224, 254);
    }
    
    if (indexPath.item == currentDog) {
        cell.coverView.hidden = YES;
    } else {
        cell.coverView.hidden = NO;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    currentDog = indexPath.item;
    _dog = self.dogs[indexPath.item];
    _record = [DoggyModel getRecordWithDoggyName:_dog date:[NSDate date]];
    if (_record) {
        _recordDic = [DoggyModel DictionartFromRecord:_record WithDog:_dog];
    }
    
    if (_dog.sex.integerValue == 0) {
        _tableDic = [@{@"体内驱虫":@NO,@"体外驱虫":@NO,@"细小病毒免疫":@NO,@"犬瘟热病毒免疫":@NO,@"冠状病毒免疫":@NO,@"狂犬病疫苗":@NO,@"弓形虫疫苗":@NO,@"怀孕":@NO,@"分娩":@NO,@"绝育":@NO} mutableCopy];
    } else {
        _tableDic = [@{@"体内驱虫":@NO,@"体外驱虫":@NO,@"细小病毒免疫":@NO,@"犬瘟热病毒免疫":@NO,@"冠状病毒免疫":@NO,@"狂犬病疫苗":@NO,@"弓形虫疫苗":@NO,@"绝育":@NO} mutableCopy];
    }
    
    NSLog(@"%@",_recordDic);
    [self.collectionView reloadData];
    [self.tableView reloadData];
}

#pragma mark - other
//imagewithColor
- (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}



@end










