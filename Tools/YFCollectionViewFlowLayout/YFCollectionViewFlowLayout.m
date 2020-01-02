//
//  YFCollectionViewFlowLayout.m
//  QYSanitation
//
//  Created by ggg on 2019/12/31.
//  Copyright © 2019 YUEFENG. All rights reserved.
//

#import "YFCollectionViewFlowLayout.h"

@implementation YFCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
}

//#pragma mark - cell的左右间距

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {

    NSMutableArray * answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    /* 处理左右间距 */
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        NSInteger maximumSpacing = self.minimumInteritemSpacing;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}

@end
