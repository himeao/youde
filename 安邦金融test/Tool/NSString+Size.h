//
//  NSString+Size.h
//  LiCaiBang
//
//  Created by 支梦召 on 16/11/1.
//  Copyright © 2016年 AnBang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Size)
- (CGSize) textSizeWithFont:(UIFont *) font
          constrainedToSize:(CGSize) size
              lineBreakMode:(NSLineBreakMode) lineBreakMode;

@end
