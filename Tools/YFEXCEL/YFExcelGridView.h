//
//  YFExcelGridView.h
//  YFTools
//
//  Created by yf on 2019/12/12.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kSepLineWidth  2
#define kSepLineColor  [UIColor blackColor]


@interface YFExcelGridView : UICollectionView



- (void)setContents:(NSArray *)contents itemSizes:(NSArray *)itemSizes ;

+(NSArray *)itemSizesForStrs:(NSArray *)strs ;

@end

NS_ASSUME_NONNULL_END
