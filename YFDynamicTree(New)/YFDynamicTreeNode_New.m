//
//  YFDynamicTreeNode_New.m
//  YFTools
//
//  Created by yf on 2019/12/13.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFDynamicTreeNode_New.h"


@implementation YFDynamicTreeNode_New

//- (id)copyWithZone:(NSZone *)zone {
//    
//    
//}

- (BOOL)isRoot{
    return self.fatherNodeID == nil ;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"name:%@",self.name];
}


@end
