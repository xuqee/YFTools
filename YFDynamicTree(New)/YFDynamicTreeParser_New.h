//
//  YFDynamicTreeParser_New.h
//  YFTools
//
//  Created by yf on 2019/12/13.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFDynamicTreeNode_New.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFDynamicTreeParser_New : NSObject

///初始化一些关键的keyword
- (void)setDeptKey:(NSString *)deptKey
         memberKey:(NSString *)memberKey
       deptNameKey:(NSString *)deptNameKey
     memberNameKey:(NSString *)memberNameKey
      deptModelCls:(Class )deptModelCls
    memberModelCls:(Class )memberModelCls ;

- (void)generateData:(NSArray *)datas
           treeNodes:(NSMutableArray<YFDynamicTreeNode_New *> * __nonnull)treeNodes
           showNodes:(NSMutableArray<YFDynamicTreeNode_New *> * __nonnull)showNodes ;

///已经选择的member对应的model
+ (NSArray *)selectedMemberModelsFromTreeNodes:(NSArray<YFDynamicTreeNode_New *> *)nodes ;
///所有的子member(成员)对应的model
+ (NSArray *)memberModelsFromTreeNodes:(NSArray<YFDynamicTreeNode_New *> *)nodes ;

@end

NS_ASSUME_NONNULL_END
