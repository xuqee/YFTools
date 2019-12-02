//
//  YFDynamicTreeNode.m
//  YFTools
//
//  Created by yf on 2019/11/26.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFDynamicTreeNode.h"

@implementation YFDynamicTreeNode

- (BOOL)isRoot
{
    return self.fatherNodeId == nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@",self.name];
}

@end
