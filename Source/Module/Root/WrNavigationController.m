//
//  WrNavigationController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/8.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WrNavigationController.h"
#import <YYKit/YYKit.h>
@interface WrNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation WrNavigationController

+(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, YYScreenSize().width, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate= self;
    
    //    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setTranslucent:NO];

    // Do any additional setup after loading the view.
}
-(void)onClickedBackButton:(UIBarButtonItem *)sender
{
    [self popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_black"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedBackButton:)];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationBar setBackgroundImage:[WrNavigationController imageWithColor:[UIColor whiteColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationBar  setShadowImage:[WrNavigationController imageWithColor:[UIColor colorWithHexString:@"#eeeeee"]]];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    //    [[UINavigationBar appearance] lt_setBackgroundColor:[UIColor wr_rehabBlueColor]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19] /*,NSShadowAttributeName:shadow*/}];;

}
-(void)hui
{
    [self popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void
   )navigationController:(UINavigationController *)navigationController
willShowViewController:(UIViewController *)viewController animated:(BOOL
                                                                    )animated
{
    [viewController viewWillAppear:animated];
}

- (void
   )navigationController:(UINavigationController *)navigationController
didShowViewController:(UIViewController *)viewController animated:(BOOL
                                                                   )animated
{
    [viewController viewDidAppear:animated];
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
