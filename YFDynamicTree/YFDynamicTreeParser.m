//
//  YFDynamicTreeParser.m
//  YFTools
//
//  Created by yf on 2019/11/26.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFDynamicTreeParser.h"

@implementation YFDynamicTreeParser{
    
    NSString *_deptNameKey ;
    NSString *_memberNameKey ;
    NSString *_deptKey ;
    NSString *_memberKey ;
    Class _deptModelCls ;
    Class _memberModelCls ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _treeNodes =        [NSMutableArray array] ;
        _showNodes =        [NSMutableArray array] ;
        _selectedNodes =   [NSMutableArray array] ;
    }
    return self ;
}


#pragma mark -- 解析
///递归解析，将所有model解析成Node
- (void)generateData:(NSArray *)datas finish:(dispatch_block_t)finish {
     DLog(@"data generate!");
    if (datas.count == 0) {
        return ;
    }
    [_showNodes removeAllObjects];
    [_treeNodes removeAllObjects] ;
    
    //递归解析node
    for (NSDictionary *dic in datas) {
        [self parseDepartmentFromDic:dic fatherNodeID:nil fatherName:@"" level:0 ];
    }

     //展开第一级
    if (self.showNodes.count ==1 ) {
        [self addSubNodesByFatherNode:self.showNodes.firstObject atIndex:0];
    }
    
    //递归算每个branch对应的人数
    if (_treeNodes.count > 0) {
        [self parseTotalCountOfSubMembersInNode:_treeNodes.firstObject] ;
        [self parserOnlineCountOfSubMembersInNode:_treeNodes.firstObject];
    }
    
    finish ? finish() : nil ; //刷新UI
}
/**
 递归解析node
 
 @param dic  需要解析的dic
 @param fatherID dic的父nodeID
 @param level dic的层级
 @return node
 */
- (YFDynamicTreeNode *)parseDepartmentFromDic:(NSDictionary *)dic
                                 fatherNodeID:(NSString *)fatherID  fatherName:(NSString *)fatherName
                                        level:(NSInteger)level {
    
    YFDynamicTreeNode *node = [[YFDynamicTreeNode alloc] init];
    
    @synchronized (self) {
        node.fatherNodeId = fatherID ;
        if (isEmptyStr(fatherID)) {
            [_showNodes addObject:node ];
        }
        node.originX = level*20 ;
        node.selectedSubMemberCount = 0 ;
        node.isSelected = NO ;
        node.isOpen = NO ;
        if (!isEmptyStr(dic[_deptNameKey])) { //组
            [self addBranchNode:node withDic:dic level:level];
        }else{
            [self addMemberNode:node withDic:dic fatherID:fatherID fatherName:fatherName];
        }
    }
    return node ;
}

-(void)addBranchNode:(YFDynamicTreeNode *)node  withDic:(NSDictionary *)dic level:(NSInteger)level  {
    
    id deptModel = [_deptModelCls modelWithDictionary:dic]  ;
    if (deptModel) {
         NSString *str = [@"_" stringByAppendingString:_deptNameKey];
         node.name = [deptModel valueForKey:str];
         node.data = deptModel;
         node.nodeId = [deptModel valueForKey:@"_ID"] ;
         node.isDepartment = YES ;
         
        if (!node.nextLevelNodes) {
            node.nextLevelNodes = [[NSMutableArray alloc] init];
        }
        [_treeNodes addObject:node ];
        
        //添加下属成员
        NSArray *members = [NSArray arrayWithArray:dic[_memberKey]];
        for (NSDictionary *member  in members  ) {
            @autoreleasepool {
                YFDynamicTreeNode *subNode = [self parseDepartmentFromDic:member fatherNodeID:node.nodeId fatherName:node.name level:(level+1)];
                [node.nextLevelNodes addObject:subNode];
            }
        }
        //添加子组织
        NSArray *subDepartments = [NSArray arrayWithArray: dic[_deptKey]] ;
        for (NSDictionary *subDepartment in subDepartments) {
            @autoreleasepool {
                YFDynamicTreeNode *subNode =
                [self parseDepartmentFromDic:subDepartment fatherNodeID:node.nodeId fatherName:node.name level:(level+1)];
                [node.nextLevelNodes addObject:subNode];
            }
        }
    }
}

-(void)addMemberNode:(YFDynamicTreeNode *)node  withDic:(NSDictionary *)dic fatherID:(NSString *)fatherID  fatherName:(NSString *)fatherName {
    id memberModel = [_memberModelCls modelWithDictionary:dic];
    [memberModel setValue:fatherID forKey:@"_fatherID"];
    [memberModel setValue:fatherName forKey:@"_fatherName"];
    if (memberModel) {
        NSString *str = [@"_" stringByAppendingString:_memberNameKey];
        node.name = [memberModel valueForKey:str];
        node.data =  memberModel ;
        node.nodeId = [memberModel valueForKey:@"_ID"];
        node.isDepartment = NO ;
        node.nextLevelNodes = nil ;
        [_treeNodes addObject:node ];
    }
}

#pragma mark -- open Or  fold action
- (void)minisNodeByNode:(YFDynamicTreeNode *)node{
    if (!node) {
        return ;
    }
    [node.nextLevelNodes enumerateObjectsUsingBlock:^(YFDynamicTreeNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_treeNodes containsObject:obj]) {
            [self.showNodes removeObject:obj];
            [self minisNodeByNode:obj];
        }
    }];
    node.isOpen = NO ;
}

///添加子节点
- (void)addSubNodesByFatherNode:(YFDynamicTreeNode *)fatherNode atIndex:(NSInteger )index {
    if (!fatherNode) {
        return ;
    }
    for (YFDynamicTreeNode *node in fatherNode.nextLevelNodes) {
        if ([_treeNodes containsObject:node]) {
            [_showNodes insertObject:node atIndex:++index];
        }
    }
    fatherNode.isOpen = fatherNode.nextLevelNodes.count > 0 ;
}


#pragma mark -- selected Node
/// 递归选择到底 选择之前记得先把node.selected = !node.selected。
/// 09.09.30  nodes 调整为在初始化的时候赋值
/// 以前通过_nodesArray1000多条数据肉眼看得到迟钝

- (NSInteger)selectAllSubNodesOfNode:(YFDynamicTreeNode *)node{
    [node.nextLevelNodes enumerateObjectsUsingBlock:^(YFDynamicTreeNode *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = node.isSelected ;
        obj.isSelected ? [self.selectedNodes addObject:obj] :[self.selectedNodes removeObject:obj];
        if (obj.isDepartment) {
            node.selectedSubMemberCount += [self selectAllSubNodesOfNode:obj ];
        }else{
            node.selectedSubMemberCount += (obj.isSelected ? 1:-1) ;
        }
    }];
    return node.selectedSubMemberCount ;
}

#pragma mark -- 子成员
///选择所有的子member(成员)对应的model
+ (NSArray *)memberModelsFromTreeNodes:(NSArray<YFDynamicTreeNode *> *)nodes{
    __block  NSMutableArray *models = [NSMutableArray array] ;
    [nodes enumerateObjectsUsingBlock:^(YFDynamicTreeNode * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!node.isDepartment) {
            [models addObject:node.data] ;
        }
    }];
    return models ;
}

///计算各个子节点的员工数量
- (NSInteger )parseTotalCountOfSubMembersInNode:(YFDynamicTreeNode *)node{
    [node.nextLevelNodes enumerateObjectsUsingBlock:^(YFDynamicTreeNode *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_treeNodes containsObject:obj] ) {
            if (obj.isDepartment) {
                NSInteger i = [self parseTotalCountOfSubMembersInNode:obj] ;
                node.subMemberCount += i ;
            }else{
                node.subMemberCount++ ;
            }
        }
    }];
    return node.subMemberCount ;
}

///计算各个子节点的员工数量
- (NSInteger )parserOnlineCountOfSubMembersInNode:(YFDynamicTreeNode *)node{
    [node.nextLevelNodes enumerateObjectsUsingBlock:^(YFDynamicTreeNode *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isDepartment) {
            NSInteger i = [self parserOnlineCountOfSubMembersInNode:obj] ;
            node.onlineCount += i ;
        }else{
            id model = obj.data ;
            NSInteger onlineType = [[model valueForKey:@"_onlineType"] integerValue] ;
            node.onlineCount += (onlineType>0) ;
        }
    }];
    return node.onlineCount ;
}


#pragma mark -- setup
- (void)setDeptKey:(NSString *)deptKey
         memberKey:(NSString *)memberKey
       deptNameKey:(NSString *)deptNameKey
     memberNameKey:(NSString *)memberNameKey
      deptModelCls:(Class )deptModelCls
    memberModelCls:(Class )memberModelCls {
    
    _deptKey = deptKey ;
    _memberKey = memberKey ;
    _deptNameKey = deptNameKey ;
    _memberNameKey = memberNameKey ;
    _deptModelCls = deptModelCls ;
    _memberModelCls = memberModelCls ;
}

@end
