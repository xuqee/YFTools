//
//  YFNavigationController.m
//  YFTools
//
//  Created by yf on 2019/12/3.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFNavigationController.h"

@interface YFNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation YFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configTitleTextStyle];
  
    self.navigationBar.tintColor = [UIColor darkGrayColor];
    
    self.interactivePopGestureRecognizer.delegate = self;
    
    UIImage *image = [UIImage imageNamed:@"icon_navi_back"] ;
    if (@available(iOS 11 , *)) {// 如果iOS 11走else的代码，系统自己的文字和箭头会出来
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
        [UINavigationBar appearance].backIndicatorImage = image;
        [UINavigationBar appearance].backIndicatorTransitionMaskImage = image;
    }else {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
}

/**
  *  设置导航上的title显示样式，白色文字
  */
-(void)configTitleTextStyle{
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 0);
    UIColor *textColor = [UIColor blackColor];
    [self.navigationBar
         setTitleTextAttributes:
                                @{NSForegroundColorAttributeName:textColor,
                                  NSShadowAttributeName:shadow,
                                  NSFontAttributeName:[UIFont systemFontOfSize:18]
                                  }
    ];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.childViewControllers.count == 1){
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
