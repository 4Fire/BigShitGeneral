//
//  TableCellTableViewCell.h
//  大将军
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCellTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lab;
- (CGFloat)setLabText:(NSString*)text;
@end
