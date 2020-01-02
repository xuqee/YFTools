//
//  YFExcelGridView.m
//  YFTools
//
//  Created by yf on 2019/12/12.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFExcelGridView.h"
#import "YFCollectionViewFlowLayout.h"

static NSString *const kYFExcelGridCellIdentify = @"com.YF.Excel.GridCell" ;

@interface YFExcelGridView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)   NSArray *contents ;
@property (nonatomic, strong)   NSArray *itemSizes ;

@end

@implementation YFExcelGridView

- (instancetype)init{
    YFCollectionViewFlowLayout *flowLayout = [[YFCollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = kSepLineWidth;
    self = [super initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    if (self ) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator=YES;
        self.bounces = NO;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kYFExcelGridCellIdentify];
        self.delegate = self ;
        self.dataSource = self ;
        self.backgroundColor = kSepLineColor;
    }
    return self ;
}

- (void)setContents:(NSArray *)contents itemSizes:(NSArray *)itemSizes{
    _contents = contents ;
    _itemSizes = itemSizes;
    [self reloadData];
}
 
#pragma mark -- collectionView
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFExcelGridCellIdentify forIndexPath:indexPath ];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [cell viewWithTag:2000];
    if (!label) {
        label = [[UILabel alloc] init ];
        label.tag = 2000 ;
        label.textColor = [UIColor darkTextColor];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 2 ;
        label.textAlignment = NSTextAlignmentCenter ;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    label.text = _contents[indexPath.row];
    return cell ;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _contents.count ;
}
 
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return NO ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sizeStr = _itemSizes[indexPath.row];
    CGSize size = CGSizeFromString(sizeStr);
    return  size ;
}


+(NSArray *)itemSizesForStrs:(NSArray *)strs {
    NSMutableArray *itemSizes = [NSMutableArray arrayWithCapacity:strs.count];
    for (NSString *str in strs) {
        CGFloat width = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width ;
        /*****注意取整，否则会出现某个间隔线很粗的情况*****/
        /*****因为在计算frame的时候，origin都会以0.5或者1开头，最后导致有的线是1 有的线粗度是2****/
        NSInteger iWidth = (NSInteger)(width>100 ? width/2.+12  : width+12) ;
        CGSize size =  CGSizeMake(iWidth, 40);
        [itemSizes addObject:NSStringFromCGSize(size)];
    }
    return itemSizes ;
}

////多种手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if ([[gestureRecognizer class] isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO ;
    }
    return YES;
}


@end
