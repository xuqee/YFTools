//
//  YFDynamicTreeParser.h
//  YFTools
//
//  Created by yf on 2019/11/26.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFDynamicTreeNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFDynamicTreeParser : NSObject

@property (nonatomic, strong)   NSMutableArray  <YFDynamicTreeNode *> *treeNodes;
///tableview需要显示的nodes
@property (nonatomic, strong)   NSMutableArray  <YFDynamicTreeNode *> *showNodes ;

@property (nonatomic, strong)   NSMutableArray  <YFDynamicTreeNode *> *selectedNodes ;


///递归解析，将所有数据解析成Node
- (void)generateData:(NSArray *)datas finish:(dispatch_block_t)finish ;
///取消选择node及其子node
- (void)minisNodeByNode:(YFDynamicTreeNode *)node  ;
///选择node及其子node
- (void)addSubNodesByFatherNode:(YFDynamicTreeNode *)fatherNode atIndex:(NSInteger )index ;


///选择所有的子member(成员)对应的model
+ (NSArray *)memberModelsFromTreeNodes:(NSArray<YFDynamicTreeNode *> *)nodes ;

/////选择所有的子Node(机构和成员)
//+ (NSArray *)allSubNodesOfNode:(YFDynamicTreeNode *)node ;
//


#pragma mark -- selected Node
/// 递归选择到底 选择之前记得先把node.selected = !node.selected。
/// 09.09.30  nodes 调整为在初始化的时候赋值
/// 以前通过_nodesArray1000多条数据肉眼看得到迟钝

- (NSInteger)selectAllSubNodesOfNode:(YFDynamicTreeNode *)node ;


///初始化一些关键的keyword
- (void)setDeptKey:(NSString *)deptKey
         memberKey:(NSString *)memberKey
       deptNameKey:(NSString *)deptNameKey
     memberNameKey:(NSString *)memberNameKey
      deptModelCls:(Class )deptModelCls
    memberModelCls:(Class )memberModelCls ;


@end

NS_ASSUME_NONNULL_END
