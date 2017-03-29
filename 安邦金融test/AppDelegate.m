//
//  AppDelegate.m
//  安邦金融test
//
//  Created by 刘刚 on 16/10/31.
//  Copyright © 2016年 支梦召. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
     self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:[self setupViewControllers]];
    
    [ self.window makeKeyAndVisible];
    
    [self customizeInterface];
    
    return YES;
}





- (RDVTabBarController *)setupViewControllers{
    SelectVC *selectVC = [[SelectVC alloc] init];
    ABNavigationVC *selectNav = [[ABNavigationVC alloc]initWithRootViewController:selectVC];
    
    
    CombinationPlanVC *combinationPlanVC = [[CombinationPlanVC alloc] init];
    ABNavigationVC *combinationPlanNav = [[ABNavigationVC alloc]initWithRootViewController:combinationPlanVC];
    
    G3TimeVC *g3TimeVC = [[G3TimeVC alloc]init];
    ABNavigationVC *G3TimeNav = [[ABNavigationVC alloc]initWithRootViewController:g3TimeVC];
    
    ProductVC *productVC = [[ProductVC alloc]init];
    ABNavigationVC *productNav = [[ABNavigationVC alloc]initWithRootViewController:productVC];
    
    AssetsVC *assetsVC = [[AssetsVC alloc]init];
    ABNavigationVC *assetsNav = [[ABNavigationVC alloc]initWithRootViewController:assetsVC];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[selectNav, combinationPlanNav,G3TimeNav,productNav,assetsNav]];
    [self customizeTabBarForController:tabBarController];
    
    return tabBarController;
}
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"s", @"pm", @"g3time",@"pl",@"my"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBadgePositionAdjustment:UIOffsetMake(30, 30)];
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
       
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_select",[tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@",[tabBarItemImages objectAtIndex:index]]];
        if (index == 2) {
            [item setFinishedSelectedImage:unselectedimage withFinishedUnselectedImage:unselectedimage];
        }else{
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        }
        index++;
    }
}


- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
