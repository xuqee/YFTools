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

@property (nonatomic, strong)   UITableView     *indexTableView ;
@property (nonatomic, strong)   UIScrollView    *scrollView ;
@property (nonatomic, strong)   UITableView     *tableView ;
@property (nonatomic, strong)   UIView           *container ;

@end

@implementation YFEXCELView

- (instancetype)init{
    self = [super init];
    if (self ) {
        self.backgroundColor = [UIColor whiteColor] ;
        [self indexTableView];
        [self scrollView];
        [self tableView];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self ;
}
 

#pragma mark -- UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableView == tableView) {
         YFExcellistCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFEXCELCellIdentify ];
         return cell ;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFEXCELIndexCellIdentify ];
        cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
        cell.textLabel.textColor = [UIColor redColor];
        return cell ;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YFExcelGridView *header = [[YFExcelGridView alloc] init];
    return header ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40 ;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _datas.count ;
    return 50 ;
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
        _scrollView.bounces = NO ;
        _scrollView.showsVerticalScrollIndicator = YES ;
        _scrollView.showsHorizontalScrollIndicator = YES ;

        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kIndexCellWidth+1));
            make.top.bottom.right.equalTo(self);
        }];
        
        _container = [[UIView alloc] init ];
        [_scrollView addSubview:_container];
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(@(kScreenWidth*2));
            make.height.equalTo(self.scrollView);
        }];
    }
    return _scrollView ;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[YFExcellistCell class] forCellReuseIdentifier:kYFEXCELCellIdentify ];
        _tableView.delegate = self ;
        _tableView.dataSource = self ;
        _tableView.showsVerticalScrollIndicator = NO ;
        _tableView.bounces = NO ;
        [_container addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
            make.width.equalTo(@(2*kScreenWidth));
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
