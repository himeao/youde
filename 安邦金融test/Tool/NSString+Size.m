//
//  NSString+Size.m
//  LiCaiBang
//
//  Created by 支梦召 on 16/11/1.
//  Copyright © 2016年 AnBang. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)
- (CGSize) textSizeWithFont:(UIFont *) font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    CGSize textSize;
    // 如果size 是空的话
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        textSize = [self sizeWithAttributes:attributes];
    } else {
        // 如果文本超出了指定矩形的限制， 文本将被截去并在最后一个字符后面加上省略号，
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        CGRect rect = [self boundingRectWithSize:size options:option attributes:attributes context:nil];
        
        textSize = rect.size;
        
    }
    return textSize;
}
@end

