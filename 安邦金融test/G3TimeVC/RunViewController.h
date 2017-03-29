//
//  RunViewController.h
//  安邦金融test
//
//  Created by 支梦召 on 2017/3/6.
//  Copyright © 2017年 支梦召. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^testBlock)(NSString *);

@interface RunViewController : UIViewController
//Block作为属性<pre name="code" class="objc">
@property(nonatomic,strong)testBlock testBlock;




-(void)backNameWithBlock:(testBlock)testBlock;

@end
