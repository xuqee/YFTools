//
//  YFDynamicTreeParser.m
//  YFTools
//
//  Created by yf on 2019/12/13.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFDynamicTreeParser.h"
#import "NSString+PinYin.h"
@interface YFDynamicTreeParser (){
    NSString *_deptNameKey ;
    NSString *_memberNameKey ;
    NSString *_deptKey ;
    NSString *_memberKey ;
    Class _deptModelCls ;
    Class _memberModelCls ;
}

@end

@implementation YFDynamicTreeParser

- (instancetype)init{
    self = [super init ] ;
    if (self) {
        _treeNodes = [NSMutableArray array] ;
        _showNodes = [NSMutableArray array] ;
    }
    return self ;
}

+ (NSMutableArray *)selectedMemberModelsFromTreeNodes:(NSArray<YFDynamicTreeNode *> *)nodes{
    __block  NSMutableArray *models = [NSMutableArray array] ;
    [nodes enumerateObjectsUsingBlock:^(YFDynamicTreeNode * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!node.isDepartment && node.isSelected) {
            [models addObject:node.data] ;
        }
    }];
    return models ;
}


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

#pragma mark -- 解析node

- (void)generateData:(NSArray *)datas
           treeNodes:(NSMutableArray<YFDynamicTreeNode *> * __nonnull)treeNodes
           showNodes:(NSMutableArray<YFDynamicTreeNode *> * __nonnull)showNodes {
   
    self.treeNodes = treeNodes  ;
    self.showNodes = showNodes  ;
    [self generateData:datas];
}

- (void)generateData:(NSArray *)datas{
    
    if (datas.count==0)  return;
    [self.treeNodes removeAllObjects];
    [self.showNodes removeAllObjects];
    
    for (NSDictionary *dic  in datas) {
        @autoreleasepool {
            [self parserDic:dic fatherID:nil fatherName:nil level:0  ];
        }
    }
    for (YFDynamicTreeNode *node in _showNodes) {
        @autoreleasepool {
            [self parseTotalCountOfSubMembersInNode:node];
        }
    }
}

/**
递归解析node

@param  dic  需要解析的dic
@param  fatherID dic的父nodeID
@param  fatherName 父name
@param   level dic的层级
@return node
*/
- (YFDynamicTreeNode *)parserDic:(NSDictionary *)dic  fatherID:(NSString *)fatherID fatherName:(NSString *)fatherName level:(NSInteger )level {
    
    YFDynamicTreeNode *node = [[YFDynamicTreeNode alloc] init];
    @synchronized (self) {
        
        if (!isEmptyStr(dic[_deptNameKey])) { //分支
            id deptModel = [_deptModelCls modelWithDictionary:dic];
            if (!deptModel) return nil ;
            
            [_treeNodes addObject:node];
            node.name = [deptModel valueForKey:[@"_" stringByAppendingString:_deptNameKey]];
            node.data = deptModel;
            node.nodeId = [deptModel valueForKey:@"_ID"] ;
            node.isDepartment = YES ;
            
            if (!node.nextLevelNodes) {
                node.nextLevelNodes = [NSMutableArray array];
            }
            //解析子node
            NSArray *members = [NSArray arrayWithArray:dic[_memberKey]];
            [members enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YFDynamicTreeNode *subNode = [self parserDic:obj fatherID:node.nodeId fatherName:node.name level:(level+1) ];
                [node.nextLevelNodes addObject:subNode];
            }];
            
            NSArray *subDeparts = [NSArray arrayWithArray:dic[_deptKey]];
            [subDeparts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YFDynamicTreeNode *subNode =
                [self parserDic:obj fatherID:node.nodeId fatherName:node.name level:level+1  ];
                [node.nextLevelNodes addObject:subNode];
            }];
    
        }else{ //member
            id memberModel = [_memberModelCls modelWithDictionary:dic];
            if (!memberModel)  return nil ;
            
            [_treeNodes addObject:node];
            node.name = [memberModel valueForKey:[@"_" stringByAppendingString:_memberNameKey]];
            node.data = memberModel ;
            node.nodeId = [memberModel valueForKey:@"_ID"] ;
            node.isDepartment = NO ;
            node.nextLevelNodes = nil ;
        }
        
        node.fatherNodeID = fatherID ;
        node.fatherNodeName = fatherName ;
        node.level = level ;
        node.isSelected = NO ;
        node.isOpen = NO ;
        node.selectedSubMemberCount = 0 ;
        
        if (isEmptyStr(fatherID)) {
            [_showNodes addObject:node];
        }
    }
    node.pinyinName = isEmptyStr(node.name) ? @"":[[NSString transformToPinyin:node.name] lowercaseString];
    return node ;
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


#pragma mark -- key

///初始化一些关键的keyword
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
