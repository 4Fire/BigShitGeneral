
//
//  TableCellTableViewCell.m
//  大将军
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "TableCellTableViewCell.h"

@interface TableCellTableViewCell ()
@property (nonatomic, strong) NSArray<UIColor *> *colors;
@end

@implementation TableCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeUserInterface {
    [self addSubview:self.lab];
    self.backgroundColor = BACKGROUNDCOLOR;
}

//赋值 and 自动换行,计算出cell的高度
- (CGFloat)setLabText:(NSString*)text {
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.lab.text = text;
    self.lab.textColor = self.colors[arc4random() % 7];
    //设置label的最大行数
    self.lab.numberOfLines = 0;
//    CGSize size = CGSizeMake(SCREEN_WIDTH - 20, self.lab.bounds.size.height - 20);
    CGRect labRect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 300) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.lab.font} context:nil];
    self.lab.frame = CGRectMake(10, 10, labRect.size.width, labRect.size.height + 20);
//    NSLog(@"########%lf",labRect.size.height);
    //计算出自适应的高度
    frame.size.height = CGRectGetHeight(self.lab.frame);
    self.frame = frame;
    return frame.size.height + 20;
}

- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] init];
        _lab.frame = CGRectMake(10, 20, SCREEN_WIDTH - 20, self.bounds.size.height - 20);
        _lab.numberOfLines = 0;
        _lab.lineBreakMode = NSLineBreakByCharWrapping;
        _lab.textColor = _colors[arc4random() % 7];
    }
    return _lab;
}

- (NSArray<UIColor *> *)colors {
    return @[COLOR(247, 68, 97), COLOR(147, 224, 254), COLOR(255, 95, 73), COLOR(236, 1, 18), COLOR(177, 153, 185), COLOR(140, 221, 73), COLOR(172, 237, 239)];
}
@end
