//
//  YFDynamicTreeParser.h
//  YFTools
//
//  Created by yf on 2019/12/13.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFDynamicTreeNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFDynamicTreeParser : NSObject

@property (nonatomic, strong)   NSMutableArray *treeNodes ;
@property (nonatomic, strong)   NSMutableArray *showNodes ;

///初始化一些关键的keyword
- (void)setDeptKey:(NSString *)deptKey
         memberKey:(NSString *)memberKey
       deptNameKey:(NSString *)deptNameKey
     memberNameKey:(NSString *)memberNameKey
      deptModelCls:(Class )deptModelCls
    memberModelCls:(Class )memberModelCls ;

- (void)generateData:(NSArray *)datas
           treeNodes:(NSMutableArray<YFDynamicTreeNode *> * __nonnull)treeNodes
           showNodes:(NSMutableArray<YFDynamicTreeNode *> * __nonnull)showNodes ;

///已经选择的member对应的model
+ (NSMutableArray *)selectedMemberModelsFromTreeNodes:(NSArray<YFDynamicTreeNode *> *)nodes ;
///所有的子member(成员)对应的model
+ (NSMutableArray *)memberModelsFromTreeNodes:(NSArray<YFDynamicTreeNode *> *)nodes ;

@end

NS_ASSUME_NONNULL_END
