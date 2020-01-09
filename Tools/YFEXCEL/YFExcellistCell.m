//
//  YFExcellistCell.m
//  YFTools
//
//  Created by yf on 2019/12/13.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFExcellistCell.h"



@interface YFExcellistCell ()<UIScrollViewDelegate>



@end

@implementation YFExcellistCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kSepLineColor ;
        _gridView = [[YFExcelGridView alloc] init];
        [self.contentView addSubview:_gridView];
        [_gridView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).offset(-kSepLineWidth);
        }];
    }
    return self ;
}
 
////多种手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
