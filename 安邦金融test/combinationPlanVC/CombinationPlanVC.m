//
//  combinationPlanVC.m
//  安邦金融test
//
//  Created by 刘刚 on 16/10/31.
//  Copyright © 2016年 支梦召. All rights reserved.
//

#import "CombinationPlanVC.h"

@interface CombinationPlanVC ()

@end

@implementation CombinationPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:29]];
    [btn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.size.equalTo(CGSizeMake(80, 20));
    }];
    
}
- (NSInteger)intToBinary:(NSInteger)intValue{
    NSInteger byteBlock = 8,    // 每个字节8位
    totalBits = sizeof(NSInteger) * byteBlock, // 总位数（不写死，可以适应变化）
    binaryDigit = 1;  // 当前掩（masked）位
    NSInteger count = 0;
    do{
        // 检出下一位，然后向左移位，附加 0 或 1
        if (intValue & binaryDigit) {
            count ++;
        }
        // 移到下一位
        binaryDigit <<= 1;
    } while (totalBits);
    
    return count;
}

@end
