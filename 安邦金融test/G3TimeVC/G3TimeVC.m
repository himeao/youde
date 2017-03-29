//
//  G3TimeVC.m
//  安邦金融test
//
//  Created by 刘刚 on 16/10/31.
//  Copyright © 2016年 支梦召. All rights reserved.
//

#import "G3TimeVC.h"
#import "selectVC.h"
#import "RunViewController.h"

@interface G3TimeVC ()
{
UIButton *_nameBtn;
}
@end

@implementation G3TimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    [super viewDidLoad];
    _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nameBtn.frame = CGRectMake(50, 100, 100, 50);
    [_nameBtn setTitle:@"点我" forState:UIControlStateNormal];
    [_nameBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_nameBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_nameBtn addTarget:self action:@selector(run1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nameBtn];
    
    
//    RunViewController  *runVC = [[RunViewController alloc]init];
//    //block作为属性传给下一个界面
//    runVC.testBlock = ^(NSString *name){
//        
//        [_nameBtn setTitle:name forState:UIControlStateNormal];
//    };
    
}


#pragma  mark - 作为属性传递
//第一种方法
-(void)run1:(UIButton *)sender
{
    [self pushNextVCWithBlock:^(NSString *name) {
        
        [_nameBtn setTitle:name forState:UIControlStateNormal];
        
    }];
    NSLog(@"第一次");
}
-(void)pushNextVCWithBlock:(testBlock)testBlock
{
    RunViewController  *runVC = [[RunViewController alloc]init];
    //block作为属性传给下一个界面
    runVC.testBlock = testBlock;
    [self.navigationController pushViewController:runVC animated:YES];
}

//第二种方法
-(void)run2:(UIButton *)sender
{
    RunViewController  *runVC = [[RunViewController alloc]init];
    //block作为属性传给下一个界面
    runVC.testBlock = ^(NSString *name){

        [_nameBtn setTitle:name forState:UIControlStateNormal];
    };
    
    [self.navigationController pushViewController:runVC animated:YES];
}
//第三种方法
-(void)run3:(UIButton *)sender
{
    RunViewController  *runVC = [[RunViewController alloc]init];
    //block作为属性传给下一个界面
    [runVC setTestBlock:^(NSString *name){
        
        [_nameBtn setTitle:name forState:UIControlStateNormal];
        
    }];
    
    [self.navigationController pushViewController:runVC animated:YES];
}

#pragma  mark - 作为参数传递

//第二种方法
-(void)run22:(UIButton *)sender
{
    RunViewController  *runVC = [[RunViewController alloc]init];
    //block作为属性传给下一个界面
       [runVC backNameWithBlock:^(NSString *name) {
           
           [_nameBtn setTitle:name forState:UIControlStateNormal];
           
       }];
    
    [self.navigationController pushViewController:runVC animated:YES];
}

@end
