//
//  YFEXCELView.m
//  YFTools
//
//  Created by yf on 2019/12/12.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFEXCELView.h"
#import "YFExcellistCell.h"
#import "YFExcelGridView.h"
 

#define kIndexCellWidth  49
#define kDefaultCellHeight 40

static NSString *const kYFEXCELIndexCellIdentify = @"com.YF.EXCEL.IndexCell" ;
static NSString *const kYFEXCELCellIdentify = @"com.YF.EXCEL.Cell" ;

@interface YFEXCELView ()<UITableViewDelegate ,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong)   NSArray *titles ;
@property (nonatomic, strong)   NSArray *keys ;
@property (nonatomic, strong)   NSArray *datas ;

@property (nonatomic, strong)   UITableView    *indexTableView ;
@property (nonatomic, strong)   UIScrollView    *scrollView ;
@property (nonatomic, strong)   UITableView    *tableView ;
@property (nonatomic, strong)   UIView           *container ;

@property (nonatomic, strong)   NSArray         *lineItemSizes ;

@end

@implementation YFEXCELView

- (instancetype)init{
    self = [super init];
    if (self ) {
        [self setup ];
    }
    return self ;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup ];
}

- (void)setup{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
 
}

- (void)setKeys:(NSArray *)keys titles:(NSArray *)titles datas:(NSArray *)datas {
    self.keys = [NSArray arrayWithArray: keys] ;
    self.titles = [NSArray arrayWithArray: titles] ;
    self.datas = [NSArray arrayWithArray: datas] ;
    
    __block NSMutableArray *longestDatas = [NSMutableArray arrayWithArray:titles];
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (int i = 0; i<keys.count; i++) {
            NSString *value = @"";
            if ([obj isKindOfClass:[NSDictionary class]]) {
                value = [obj objectForKey:keys[i]];
            }else{
                value = [obj valueForKey:[NSString stringWithFormat:@"_%@",keys[i]]];
            }
            if (!value) continue ;
            NSString *latestLongestValue = longestDatas[i] ;
            if (value.length > latestLongestValue.length) {
                [longestDatas replaceObjectAtIndex:i withObject:value];
            }
        }
    }];
    self.lineItemSizes = [YFExcelGridView itemSizesForStrs:longestDatas];
    [self indexTableView];
    [self scrollView];
    [self tableView];
}

#pragma mark -- UITableView

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        YFExcellistCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFEXCELCellIdentify ];
        id obj = _datas[indexPath.row];
        NSMutableArray *values = [NSMutableArray array];
        for (NSString *key  in _keys) {
            NSString *value = @"";
             if ([obj isKindOfClass:[NSDictionary class]]) {
                 value = [obj objectForKey:key];
             }else{
                 value = [obj valueForKey:[NSString stringWithFormat:@"_%@",key]];
             }
            if (value) [values addObject:value];
        }
        [cell.gridView setContents:values itemSizes:self.lineItemSizes];
        return cell ;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFEXCELIndexCellIdentify ];
        UILabel *label = [cell viewWithTag:3008];
        if (!label) {
            label = [[UILabel alloc] init];
            label.tag = 3008 ;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor redColor];
            label.textAlignment = NSTextAlignmentCenter ;
            label.adjustsFontSizeToFitWidth = YES ;
            [cell.contentView addSubview:label];
            [label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(cell);
            }];
        }
        label.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        return cell ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header ;
    if (tableView == _tableView) {
        YFExcelGridView *grid = [[YFExcelGridView alloc] init];
        [grid setContents:_titles itemSizes:_lineItemSizes];
        header = grid ;
    }else{
        header = [[UIView alloc] init];
        header.backgroundColor = [UIColor whiteColor];
    }
    UIView *sep = [[UIView alloc] init];
    sep.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [header addSubview:sep];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(header);
        make.height.equalTo(@1);
    }];
    return header ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .00001 ;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO ;
}
 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset ;
    [_tableView setContentOffset:point animated:NO];
    [_indexTableView setContentOffset:point animated:NO];
}

#pragma mark -- lazy bone

- (UITableView *)indexTableView{
    if (!_indexTableView) {
        _indexTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _indexTableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _indexTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_indexTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kYFEXCELIndexCellIdentify ];
        _indexTableView.delegate = self ;
        _indexTableView.dataSource = self ;
        _indexTableView.showsVerticalScrollIndicator = NO ;
        _indexTableView.bounces = NO ;
        [self addSubview:_indexTableView];
        [_indexTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.equalTo(@(kIndexCellWidth));
        }];
    }
    return _indexTableView ;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = YES ;
        _scrollView.showsHorizontalScrollIndicator = YES ;
        _scrollView.bounces = NO ;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kIndexCellWidth+1));
            make.top.bottom.right.equalTo(self);
        }];
        
        CGFloat width = _lineItemSizes.count*.5 ;
        for (NSString *sizeStr in _lineItemSizes) {
            width += CGSizeFromString(sizeStr).width ;
        }
        _container = [[UIView alloc] init ];
        [_scrollView addSubview:_container];
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(@(width));
            make.height.equalTo(self.scrollView);
        }];
    }
    return _scrollView ;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.bounces = NO ;
        [_tableView registerClass:[YFExcellistCell class] forCellReuseIdentifier:kYFEXCELCellIdentify ];
        _tableView.delegate = self ;
        _tableView.dataSource = self ;
        _tableView.showsVerticalScrollIndicator = NO ;
        [_container addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.container);
        }];
    }
    return _tableView ;
}

////多种手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
         NSLog(@"%@",touch.view);
        return NO;
    }
    return YES;
}

@end
