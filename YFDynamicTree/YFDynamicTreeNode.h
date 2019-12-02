//
//  YFDynamicTreeNode.h
//  YFTools
//
//  Created by yf on 2019/11/26.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFDynamicTreeNode : NSObject

///坐标x
@property (nonatomic, assign)    CGFloat       originX;
///名称
@property (nonatomic, strong)    NSString      *name;
//节点详细数据
@property (nonatomic, strong)   id  data;
///下一级子节点 例如 自己为N级 下一级为N+1
@property (nonatomic, strong,nullable)   NSMutableArray *nextLevelNodes;
///父节点的id
@property (nonatomic, strong)   NSString      *fatherNodeId;
///当前节点id
@property (nonatomic, strong)   NSString      *nodeId;
///是否是部门
@property (nonatomic, assign)   BOOL          isDepartment;
///是否展开的(部门节点才有这个属性)
@property (nonatomic, assign)   BOOL isOpen;
///是否选择了
@property (nonatomic, assign)   BOOL          isSelected  ;

///所有下级的成员 /N ------ N+M ，并非N --- N+1/
@property (nonatomic, assign)   NSInteger     subMemberCount ;
///选择了的下级成员
@property (nonatomic, assign)   NSInteger     selectedSubMemberCount ;
///在线
@property (nonatomic, assign)   NSInteger onlineCount ;

 
//检查是否根节点
- (BOOL)isRoot;



@end

NS_ASSUME_NONNULL_END
