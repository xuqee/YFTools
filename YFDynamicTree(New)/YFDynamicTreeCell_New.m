//
//  YFDynamicTreeCell_New.m
//  YFTools
//
//  Created by yf on 2019/12/13.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFDynamicTreeCell_New.h"
#import "YFDynamicTreeNode_New.h"


#define kBranchCellHeight 44
#define kMemberCellHeight  49

@implementation YFDynamicTreeCell_New

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)selectedBtnClicked:(UIButton *)sender {
    _selectedBlock ? _selectedBlock() : nil ;
}

- (void)fillWithNode:(YFDynamicTreeNode_New*)node {
    
}

+ (CGFloat)heightForCellWithType:(YFDynamicCellType_New )type{
    if (type == YFDynamicCellType_NEWBranch) {
        return kBranchCellHeight;
    }
    return kMemberCellHeight;
}


@end
