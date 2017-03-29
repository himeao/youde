//
//  RunViewController.m
//  安邦金融test
//
//  Created by 支梦召 on 2017/3/6.
//  Copyright © 2017年 支梦召. All rights reserved.
//

#import "RunViewController.h"

@interface RunViewController ()
{
    ///返回按钮
    UIButton * _backBtn;
    UITextField *_text;
}
@end
@implementation RunViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"第二个页面";
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(50, 300, 100, 50);
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];

    [_backBtn addTarget:self action:@selector(backToRun:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    _text = [[UITextField alloc]initWithFrame:CGRectMake(100, 50, 200, 80)];
    _text.textColor = [UIColor greenColor];
    _text.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_text];
    
    
}

-(void)backNameWithBlock:(testBlock)testBlock{
    
    testBlock(@"wahgoh;oeahg;heaohgeoihgr;");

}



-(void)backToRun:(UIButton *)sender
{
    self.testBlock(_text.text);
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
