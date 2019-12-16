//
//  YFExcelGridView.m
//  YFTools
//
//  Created by yf on 2019/12/12.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFExcelGridView.h"

static NSString *const kYFExcelGridCellIdentify = @"com.YF.Excel.GridCell" ;

@interface YFExcelGridView ()<UICollectionViewDelegate,UICollectionViewDataSource>


@end

@implementation YFExcelGridView

- (instancetype)init{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(2*kScreenWidth/10,40);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self = [super initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    if (self ) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator=YES;
        self.bounces = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kYFExcelGridCellIdentify];
        self.delegate = self ;
        self.dataSource = self ;
    }
    return self ;
}
 
#pragma mark -- collectionView
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFExcelGridCellIdentify forIndexPath:indexPath ];
    cell.contentView.backgroundColor = RGB(25*indexPath.row, 25*indexPath.row, 25*indexPath.row);
    return cell ;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10 ;
}
 
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return NO ;
}


@end
