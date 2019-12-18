//
//  YFDynamicTree_New.m
//  YFTools
//
//  Created by yf on 2019/12/13.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFDynamicTree_New.h"
 
#import "YFDynamicTreeParser_New.h"

@interface YFDynamicTree_New ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   UITableView *tableView ;
@property (nonatomic, strong)   NSArray     *rootNodes ;
@property (nonatomic, copy)     NSString    *cellReuseIdentify ;

@end

@implementation YFDynamicTree_New

 - (instancetype)init{
     self = [super init];
     if (self) {
         [self setup];
     }
     return self ;
 }

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setTreeNodes:(NSArray *)treeNodes  rootNodes:(NSArray *)rootNodes{
    _treeNodes = [NSMutableArray arrayWithArray:treeNodes];
    _showNodes = [NSMutableArray arrayWithArray:rootNodes];
    _rootNodes = [NSMutableArray arrayWithArray:rootNodes] ;
    
    if (_treeNodes.count == 0 || rootNodes.count == 0) {
        DLog(@"no nodes show");
        [self.tableView reloadData];
        return ;
    }
    _totalMemberCount = 0 ;
    for (YFDynamicTreeNode_New *node in _showNodes) {
        _totalMemberCount += node.subMemberCount ;
    }
    if (_rootNodes.count < 5) {
        [self addSubNodesFromNode:_rootNodes.firstObject index:0];
    }
    [self.tableView reloadData];
}

#pragma mark -- Private methods
- (void)clickNode:(YFDynamicTreeNode_New *)node isSelected:(BOOL)isSelected {
    node.isSelected = isSelected ;
    [node.nextLevelNodes enumerateObjectsUsingBlock:^(YFDynamicTreeNode_New * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.treeNodes containsObject:obj]) return ;
        [self clickNode:obj isSelected:isSelected];
    }];
}
 
- (void)updateSelectedMemberCount{
    NSInteger totalSelectedMemberCount = 0 ;
    for (YFDynamicTreeNode_New *node in _rootNodes) {
        totalSelectedMemberCount += [self selectedMemberCountOfNode:node];
    }
    _selectedCount = totalSelectedMemberCount ;
}

- (NSInteger)selectedMemberCountOfNode:(YFDynamicTreeNode_New *)node{
    __block NSInteger total = 0 ;
    if (![_treeNodes containsObject:node]) return 0 ;
    
    if (node.isDepartment) {
        [node.nextLevelNodes enumerateObjectsUsingBlock:^(YFDynamicTreeNode_New * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            total += [self selectedMemberCountOfNode:obj] ;
        }];
    }else{
        total += node.isSelected ;
    }
    node.selectedSubMemberCount = total ;
    node.isSelected = (node.selectedSubMemberCount >0) ;
    return total ;
}

- (void)minisShowNodeFromNode:(YFDynamicTreeNode_New *)node{
    [node.nextLevelNodes enumerateObjectsUsingBlock:^(YFDynamicTreeNode_New * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.showNodes containsObject:obj]) {
             [self.showNodes removeObject:obj];
             [self minisShowNodeFromNode:obj];
        }
    }];
    node.isOpen = NO ;
}

- (void)addSubNodesFromNode:(YFDynamicTreeNode_New *)node index:(NSInteger)index{
    __block NSInteger row = index ;
    [node.nextLevelNodes enumerateObjectsUsingBlock:^(YFDynamicTreeNode_New * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.treeNodes containsObject:obj]) {
            [self.showNodes insertObject:obj atIndex:++row];
        }
    }];
    node.isOpen = YES ;
}

#pragma mark -- tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _showNodes.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFDynamicTreeNode_New *node = _showNodes[indexPath.row] ;
    YFDynamicCellType_New type = node.isDepartment ? YFDynamicCellType_NEWBranch : YFDynamicCellType_NEWMember ;
    return [YFDynamicTreeCell_New heightForCellWithType:type];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFDynamicTreeCell_New *cell = [tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentify] ;
    YFDynamicTreeNode_New *node = _showNodes[indexPath.row] ;
    [cell fillWithNode:node];
    cell.selectedBlock = ^{
        BOOL ret = !node.isSelected ;
        [self clickNode:node isSelected:ret]; //子nod
        [self updateSelectedMemberCount ];
        [self.tableView reloadData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicTreeSelectedNodesFinished)]) {
            [self.delegate dynamicTreeSelectedNodesFinished];
        }
    };
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YFDynamicTreeNode_New *node = _showNodes[indexPath.row] ;
    if (node.isDepartment) {
        !node.isOpen ? [self addSubNodesFromNode:node index:indexPath.row ] :   [self minisShowNodeFromNode:node] ;
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicTree: selectCellWithNode:)]) {
            [self.delegate dynamicTree:self selectCellWithNode:node];
        }
    }
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    YFDynamicTreeNode_New *node = _showNodes[indexPath.row] ;
    if (_rootNodes.count < 5 && [_rootNodes containsObject:node] && node.isOpen == YES) {
        return NO ;
    }
    return YES ;
}

#pragma mark -- UI

- (void)setup{
    self.maxSelectCount = 0 ;
    self.selectedCount = 0 ;
    [self tableView] ;
}

- (void)registCellCls:(Class)cellCls reuseIdentify:(NSString *)identify{
    self.cellReuseIdentify = identify ;
    [self.tableView registerClass:cellCls forCellReuseIdentifier:identify];
}
- (void)registCellNib:(UINib *)nib  reuseIdentify:(NSString *)identify{
    self.cellReuseIdentify = identify ;
    [self.tableView registerNib:nib forCellReuseIdentifier:identify] ;
}


#pragma mark --  Lazy

- (NSMutableArray *)selectedMembers{
    return [YFDynamicTreeParser_New selectedMemberModelsFromTreeNodes:self.treeNodes];
}

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
