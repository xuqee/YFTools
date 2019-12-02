//
//  YFDynamicTree.m
//  YFTools
//
//  Created by yf on 2019/11/26.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFDynamicTree.h"
#import "YFDynamicTreeCell.h"


@interface YFDynamicTree ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YFDynamicTree


- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self ;
}

- (void)setup{
    self.maxSelectCount =  0 ;
    _parser =   [[YFDynamicTreeParser alloc] init ];
    
    [self tableView] ;
}

- (void)generateData:(NSArray *)datas{
    [self.parser generateData:datas finish:^{
        [self.tableView reloadData];
        self.generateFinish ? self.generateFinish(): nil ;
    }];
}
 


#pragma mark -- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _parser.showNodes.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFDynamicTreeNode *node = _parser.showNodes[indexPath.row] ;
    YFDynamicCellType cellType = node.isDepartment ? YFDynamicCellTypeBranch : YFDynamicCellTypeMember ;
    return [YFDynamicTreeCell heightForCellWithType:cellType] ;
}

- (YFDynamicTreeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFDynamicTreeCell* cell = [tableView dequeueReusableCellWithIdentifier:kYFDynamicTreeCellIdentify];
    YFDynamicTreeNode *node = _parser.showNodes[indexPath.row] ;
    [cell fillWithNode: node];
    cell.selectedBlock = ^{
        node.isSelected  = !node.isSelected ;
        node.isSelected ? [self.parser.selectedNodes addObject:node] :
                                [self.parser.selectedNodes removeObject:node];
        [self.parser selectAllSubNodesOfNode:node];
        [self.tableView reloadData];
        self.selectedFinish ? self.selectedFinish() :nil;
    };
    return cell ;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    YFDynamicTreeNode *node = _parser.showNodes[indexPath.row] ;
    return node.isDepartment ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES ];
    YFDynamicTreeNode *node = _parser.showNodes[indexPath.row] ;
    if (node.isOpen) {
        [_parser minisNodeByNode:node];
    }else{
        [_parser addSubNodesByFatherNode:node atIndex:indexPath.row ];
    }
    [self.tableView reloadData];
}


#pragma mark --  Lazy

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        _tableView.delegate = self ;
        _tableView.dataSource = self ;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _tableView ;
}

@end
