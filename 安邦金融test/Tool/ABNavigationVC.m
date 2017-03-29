//
//  ABNavigationVC.m
//  安邦金融test
//
//  Created by 刘刚 on 16/10/31.
//  Copyright © 2016年 支梦召. All rights reserved.
//

#import "ABNavigationVC.h"

@interface ABNavigationVC ()

@end

@implementation ABNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animate{

    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}


@end
