//
//  YFDynamicTree.h
//  YFTools
//
//  Created by yf on 2019/12/13.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YFDynamicTreeNode.h"
 #import "YFDynamicTreeCell.h"

NS_ASSUME_NONNULL_BEGIN


@class YFDynamicTree ;


@protocol YFDynamicTreeDelegate <NSObject>

@optional

- (void)dynamicTree:(YFDynamicTree *)tree selectCellWithNode:(YFDynamicTreeNode *)node ;

- (void)dynamicTreeSelectedNodesFinished ;

@end

@interface YFDynamicTree : UIView

///最大选择数量
@property (nonatomic, assign)   NSInteger maxSelectCount ;
@property (nonatomic, assign)   NSInteger selectedCount ;
@property (nonatomic, assign)   NSInteger totalMemberCount ;

@property (nonatomic, weak) id<YFDynamicTreeDelegate> delegate ;

@property (nonatomic, strong)   NSMutableArray<YFDynamicTreeNode *> *treeNodes ;
@property (nonatomic, strong)   NSMutableArray<YFDynamicTreeNode *> *showNodes ;
@property (nonatomic, strong)   NSMutableArray* selectedMembers ;


/// 初始化需要展示的nodes
/// @param treeNodes 所有的nodes
/// @param rootNodes 根nodes
- (void)setTreeNodes:(NSArray *)treeNodes  rootNodes:(NSArray *)rootNodes ;
- (void)registCellCls:(Class)cellCls reuseIdentify:(NSString *)identify;
- (void)registCellNib:(UINib *)nib reuseIdentify:(NSString *)identify;

- (void)reloadData ;

@end

NS_ASSUME_NONNULL_END
