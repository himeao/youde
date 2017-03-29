//
//  UILabel+Size.m
//  LiCaiBang
//
//  Created by 支梦召 on 2017/1/9.
//  Copyright © 2017年 AnBang. All rights reserved.
//

#import "UILabel+Size.h"

@implementation UILabel (Size)
- (CGSize) textSizeWithFont:(CGFloat)font withMessage:(NSString *)message{
    //自动计算Label所需的宽高
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    //iOS9.0后为了避免出现“...”现象，需要将值向上取整
    CGSize adjustSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return adjustSize;
}
@end
