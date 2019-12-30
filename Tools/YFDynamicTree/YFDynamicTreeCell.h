//
//  YFDynamicTreeCell.h
//  YFTools
//
//  Created by yf on 2019/12/13.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString * _Nonnull const kYFDynamicTreeCellIdentify = @"YFDynamicTreeCell" ;

typedef enum {
    YFDynamicCellType_NEWBranch = 1, //目录
    YFDynamicCellType_NEWMember   //雇员
}YFDynamicCellType_New ;


NS_ASSUME_NONNULL_BEGIN

@class YFDynamicTreeNode ;

@interface YFDynamicTreeCell : UITableViewCell

+ (CGFloat)heightForCellWithType:(YFDynamicCellType_New )type;

- (void)fillWithNode:(YFDynamicTreeNode*)node ;

@property (nonatomic, copy) dispatch_block_t selectedBlock ;

@end

NS_ASSUME_NONNULL_END
