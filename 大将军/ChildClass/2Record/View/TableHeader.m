//
//  TableHeader.m
//  大将军
//
//  Created by 石燚 on 16/7/11.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "TableHeader.h"
#import "DateModel.h"
#import "CollectionVCell.h"

@interface  TableHeader ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collection;

@property (nonatomic, strong) DateModel *dateModel;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) BOOL changeHight;

@end

static NSInteger recode = -1;

@implementation TableHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDataSource];
        [self initUserInterface];
        
    }
    return self;
}

#pragma mark - frame
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

#pragma mark - self-init
- (void)initDataSource {
    _dateModel = [DateModel new];
    self.date = [NSDate date];
}

- (void)initUserInterface {
    self.backgroundColor = BACKGROUNDCOLOR;
    [self addSubview:self.collection];
    [self addSubview:self.headerView];
}

#pragma mark - collectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_changeHight) {
        return 42;
    }else {
        return 35;
    }
}

#pragma mark - collectionDelegate 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger firstDay = [_dateModel firstWeekdayInThisMonth:self.date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self.date];
    components.day = indexPath.row - firstDay + 1;
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    calender.timeZone = [NSTimeZone systemTimeZone];
    

    
    if ([_dateModel year:self.date] < [_dateModel year:[NSDate date]] && [_dateModel month:self.date] < [_dateModel month:[NSDate date]]) {
        recode = indexPath.row;
        NSDate *date = [calender dateFromComponents:components];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"YYYY年MM月d日";
        if ([self.tableHeaderDelegate respondsToSelector:@selector(TableHeader:selectTime:)]) {
            [self.tableHeaderDelegate TableHeader:self selectTime:[formatter stringFromDate:date]];
        }
    } else if ([_dateModel year:self.date] == [_dateModel year:[NSDate date]] && [_dateModel month:self.date] == [_dateModel month:[NSDate date]]){
        if (indexPath.row < firstDay) {
//            recode = -1;
        } else if (indexPath.row >= [_dateModel day:[NSDate date]] + firstDay) {
//            recode = -1;
        } else {
            recode = indexPath.row;
            NSDate *date = [calender dateFromComponents:components];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"YYYY年MM月d日";
            if ([self.tableHeaderDelegate respondsToSelector:@selector(TableHeader:selectTime:)]) {
                [self.tableHeaderDelegate TableHeader:self selectTime:[formatter stringFromDate:date]];
            }
        }
    } else {
        recode = -1;
    }
    
    [self.collection reloadData];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TableCalendarCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 4;
    cell.layer.masksToBounds = YES;
    
    NSInteger firstDay = [self.dateModel firstWeekdayInThisMonth:self.date];
    NSInteger total = [self.dateModel totaldaysInMonth:self.date];
    
    if (indexPath.row == recode) {
        cell.backgroundColor = COLOR(255, 95, 73);
    } else {
        cell.backgroundColor = COLOR(254, 255, 213);
    }
    
    if (indexPath.item < firstDay) {
        cell.day.text = @"";
    } else if (indexPath.item + 1 > firstDay + total) {
        cell.day.text = @"";
    } else {
        cell.day.text = [NSString stringWithFormat:@"%ld",indexPath.row - firstDay + 1];
    }
    
    if ([_dateModel year:self.date] < [_dateModel year:[NSDate date]] && [_dateModel month:self.date] < [_dateModel month:[NSDate date]]) {

        
    } else {
        
        if ([self.date compare:[NSDate date]] < 0) {
            if (indexPath.row + 1 == [_dateModel day:self.date] + firstDay) {
                cell.backgroundColor =  COLOR(1, 174, 240);
            } else if (indexPath.row + 1 > [_dateModel day:self.date] + firstDay) {
                cell.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
            }
        } else if ([self.date compare:[NSDate date]] > 0) {
            cell.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        }
    }
    

    
    return cell;
}

- (void)nextMonth {
   self.date = [_dateModel nextMonth:self.date];
}

- (void)lastMonth {
    self.date = [_dateModel lastMonth:self.date];
}

- (void)today {
    self.date = [NSDate date];
}

#pragma mark - setter
- (void)setDate:(NSDate *)date {
    _date = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY年MM月d日";
    if ([self.tableHeaderDelegate respondsToSelector:@selector(TableHeader:selectTime:)]) {
        [self.tableHeaderDelegate TableHeader:self selectTime:[formatter stringFromDate:date]];
    }
    
    NSInteger firstDay = [self.dateModel firstWeekdayInThisMonth:date];
    NSInteger total = [self.dateModel totaldaysInMonth:date];
    
    if (firstDay + total > 35) {
        _changeHight = YES;
        if ([self.tableHeaderDelegate respondsToSelector:@selector(TableHeader: changeHeight:)]) {
            [self.tableHeaderDelegate TableHeader:self changeHeight:_changeHight];
        }
    } else {
        _changeHight = NO;
        if ([self.tableHeaderDelegate respondsToSelector:@selector(TableHeader:changeHeight:)]) {
            [self.tableHeaderDelegate TableHeader:self changeHeight:_changeHight];
        }
    }
    
    _collection.frame = CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height - 20);
    [self.collection reloadData];
}

#pragma mark - getter
- (UICollectionView *)collection {
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        //设置大小
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 16) / 7, (SCREEN_WIDTH - 16 ) / 7);
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        
        
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height - 20) collectionViewLayout:layout];
        
        _collection.delegate = self;
        _collection.dataSource = self;
        [_collection registerClass:[CollectionVCell class] forCellWithReuseIdentifier:@"TableCalendarCell"];
        _collection.backgroundColor = BACKGROUNDCOLOR;
        
    }
    
    return _collection;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        for (NSInteger i = 0; i < 7; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width / 7 * i, 0, self.bounds.size.width / 7, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:18];
            label.textColor = [UIColor whiteColor];
            label.text = self.weekArray[i];
            label.backgroundColor = BACKGROUNDCOLOR;
            [self.headerView addSubview:label];
        }
    }
    return _headerView;
}

- (NSArray *)weekArray {
    return @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}


@end










