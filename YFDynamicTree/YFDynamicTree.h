//
//  YFDynamicTree.h
//  YFTools
//
//  Created by yf on 2019/11/26.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFDynamicTreeNode.h"
#import "YFDynamicTreeParser.h"


NS_ASSUME_NONNULL_BEGIN

@interface YFDynamicTree : UIView

@property (nonatomic, strong)   UITableView *tableView ;
 
@property (nonatomic, strong)  YFDynamicTreeParser* parser;

///最大选择数量
@property (nonatomic, assign)   NSInteger maxSelectCount ;
@property (nonatomic, assign)   NSInteger selectedCount ;

@property (nonatomic, copy) dispatch_block_t generateFinish ;
@property (nonatomic, copy) dispatch_block_t selectedFinish ;
 
 
- (void)generateData:(NSArray *)datas ;


@end

NS_ASSUME_NONNULL_END
