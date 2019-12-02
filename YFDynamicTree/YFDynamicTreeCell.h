//
//  YFDynamicTreeCell.h
//  YFTools
//
//  Created by yf on 2019/11/26.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFDynamicTreeNode ;

static NSString * _Nonnull const kYFDynamicTreeCellIdentify = @"YFDynamicTreeCell" ;

typedef enum {
    YFDynamicCellTypeBranch = 1, //目录
    YFDynamicCellTypeMember   //雇员
}YFDynamicCellType ;

NS_ASSUME_NONNULL_BEGIN

@interface YFDynamicTreeCell : UITableViewCell

+ (CGFloat)heightForCellWithType:(YFDynamicCellType)type;

- (void)fillWithNode:(YFDynamicTreeNode*)node ;

@property (nonatomic, copy) dispatch_block_t selectedBlock ;

@end

NS_ASSUME_NONNULL_END
