//
//  YFDynamicTree_New.h
//  YFTools
//
//  Created by yf on 2019/12/13.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YFDynamicTreeNode_New.h"
 #import "YFDynamicTreeCell_New.h"

NS_ASSUME_NONNULL_BEGIN


@class YFDynamicTree_New ;


@protocol YFDynamicTreeDelegate <NSObject>

@optional

- (void)dynamicTree:(YFDynamicTree_New *)tree selectCellWithNode:(YFDynamicTreeNode_New *)node ;

- (void)dynamicTreeSelectedNodesFinished ;

@end

@interface YFDynamicTree_New : UIView

///最大选择数量
@property (nonatomic, assign)   NSInteger maxSelectCount ;
@property (nonatomic, assign)   NSInteger selectedCount ;
@property (nonatomic, assign)   NSInteger totalMemberCount ;

@property (nonatomic, weak) id<YFDynamicTreeDelegate> delegate ;

@property (nonatomic, strong)   NSMutableArray<YFDynamicTreeNode_New *> *treeNodes ;
@property (nonatomic, strong)   NSMutableArray<YFDynamicTreeNode_New *> *showNodes ;
@property (nonatomic, strong)   NSMutableArray* selectedMembers ;


/// 初始化需要展示的nodes
/// @param treeNodes 所有的nodes
/// @param rootNodes 根nodes
- (void)setTreeNodes:(NSArray *)treeNodes  rootNodes:(NSArray *)rootNodes ;
- (void)registCellCls:(Class)cellCls reuseIdentify:(NSString *)identify;
- (void)registCellNib:(UINib *)nib reuseIdentify:(NSString *)identify;


@end

NS_ASSUME_NONNULL_END
