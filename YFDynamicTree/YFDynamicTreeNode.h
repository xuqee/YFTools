//
//  YFDynamicTreeNode.h
//  YFTools
//
//  Created by yf on 2019/12/13.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFDynamicTreeNode : NSObject

@property (nonatomic, copy)     NSString *nodeId ;
@property (nonatomic, copy)     NSString *name ;
@property (nonatomic, copy)     NSString *pinyinName ;
@property (nonatomic, strong)   id  data ;
@property (nonatomic, assign)   NSInteger   level ;


@property (nonatomic, assign)   NSString *fatherNodeID ;
@property (nonatomic, assign)   NSString *fatherNodeName ;

///下一级子节点 例如 自己为N级 下一级为N+1
@property (nonatomic, strong,nullable)   NSMutableArray<YFDynamicTreeNode *> *nextLevelNodes;

///所有下级的成员 /N ------ N+M ，并非N --- N+1/
@property (nonatomic, assign)   NSInteger     subMemberCount ;
///选择了的下级成员
@property (nonatomic, assign)   NSInteger     selectedSubMemberCount ;



///是否是部门
@property (nonatomic, assign)   BOOL          isDepartment;
///是否展开的(部门节点才有这个属性)
@property (nonatomic, assign)   BOOL isOpen;
///是否选择了
@property (nonatomic, assign)   BOOL          isSelected  ;

//检查是否根节点
- (BOOL)isRoot;

 
@end

NS_ASSUME_NONNULL_END
