//
//  TableCellInfoController.m
//  大将军
//
//  Created by 石燚 on 16/8/1.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "TableCellInfoController.h"

@interface TableCellInfoController ()

@end

@implementation TableCellInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    _infoDic = infoDic;
    NSLog(@"%@",_infoDic);
}

@end
