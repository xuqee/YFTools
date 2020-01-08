//
//  YFDatePickerContainer.m
//  YFTools
//
//  Created by yf on 2019/12/6.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFDatePickerContainer.h"

@interface YFDatePickerContainer ()

@property (nonatomic, strong)  UIDatePicker *datePicker ;
@property (nonatomic, strong)  UIToolbar     *toolBar ;

@end


@implementation YFDatePickerContainer


+(instancetype)dateContainer{
    CGFloat height = 0 ;
    if (@available(iOS 11, *)) {
        height = 30 ;
    }
    YFDatePickerContainer *container = [[YFDatePickerContainer alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 216+44+height) ];
    return container ;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *safeAreaHolder = [[UIView alloc] init ];
        safeAreaHolder.backgroundColor = [UIColor whiteColor];
        [self addSubview:safeAreaHolder];
        [safeAreaHolder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            if (@available(iOS 11, *)) {
                make.top.equalTo(self.mas_safeAreaLayoutGuideBottom);
            }else{
                make.height.equalTo(@0);
            }
        }];
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"];
        [self addSubview:_datePicker];
        [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(safeAreaHolder);
            make.bottom.equalTo(safeAreaHolder.mas_top);
        }];
        
        _toolBar = [[UIToolbar alloc] init ];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
        UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
        [_toolBar setItems:@[left,fix,right]];
        [self addSubview:_toolBar];
        [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.datePicker.mas_top);
            make.top.equalTo(self);
        }];
    }
    return self ;
}
 
- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    self.datePicker.datePickerMode = datePickerMode ;
}

- (void)showDate:(NSDate *)date {
    self.datePicker.date =  date ;
}

- (void)addMiniDate:(NSDate *)miniDate maxDate:(NSDate *)maxDate  {
    self.datePicker.maximumDate = maxDate;
    self.datePicker.minimumDate = miniDate ;
}

- (IBAction)cancel:(id)sender{
    _dismissBlock?_dismissBlock() :nil ;
}

- (IBAction)done:(id)sender{
    _dateBlock ? _dateBlock(_datePicker.date):nil ;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
