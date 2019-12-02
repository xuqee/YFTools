//
//  YFDynamicTreeCell.m
//  YFTools
//
//  Created by yf on 2019/11/26.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFDynamicTreeCell.h"
#import "YFDynamicTreeNode.h"


#define kBranchCellHeight 44
#define kMemberCellHeight  49

@implementation YFDynamicTreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithType:(YFDynamicCellType)type{
    
    if (type == YFDynamicCellTypeBranch) {
        return kBranchCellHeight;
    }
    return kMemberCellHeight;
}

- (IBAction)selectedBtnClicked:(UIButton *)sender {
    if (_selectedBlock) {
        _selectedBlock();
    }
}

// 子类实现
- (void)fillWithNode:(YFDynamicTreeNode*)node{
    self.textLabel.text = node.name ;
}

@end
