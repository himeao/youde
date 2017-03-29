//
//  Repeat.m
//  安邦金融test
//
//  Created by 支梦召 on 2017/3/21.
//  Copyright © 2017年 支梦召. All rights reserved.
//

#import "Repeat.h"
@interface Repeat()

@end
@implementation Repeat

-(instancetype)initWithFrame:(CGRect)frame textArray:(NSArray *)textArray colorArray:(NSArray *)textColorArray{
    if (self = [super init]) {
        _textArray = textArray;
        _textColorArray = textColorArray;
    
        self.frame = frame;

    }
    return self;
}

#pragma mark - 创建scrollView内容
-(void)createContentOfScrollView{
    
    //创建contentView
    self.contentSize=CGSizeMake(0, self.bounds.size.height);
    
    //偏移量初值设为0
    self.contentOffset=CGPointMake(0, 0);
    
    //关闭指示条
    self.showsHorizontalScrollIndicator=NO;
    
    //创建label
    
    CGFloat labelY=0;
    CGFloat labelW=200;
    CGFloat labelH=self.bounds.size.height;
    
    //添加两次一样的内容，无限循环使用
    for (int j=0; j<2;j++ ) {
        
        for (int i=0; i<self.textArray.count; i++) {
            
            UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.contentSize.width, labelY, labelW, labelH)];
            
            //******标签背景******
            UIImageView *labelBackGroundView=[[UIImageView alloc] initWithFrame:textLabel.frame];
            
            //标签背景图片
            labelBackGroundView.image=self.backgroundImageOfCanvas;
            
            //*****label文字******
            if (i<self.textArray.count) {
                textLabel.text=self.textArray[i];
            }else{
                textLabel.text=@"----";
            }
            
            //label文字颜色(判断文字颜色数组是否存有对应的颜色，没有则使用默认颜色)
            if (i<self.textColorArray.count) {
                textLabel.textColor=self.textColorArray[i];
            }else{
                //默认颜色
                textLabel.textColor=[UIColor blackColor];
            }
            
            //******字体大小********
            textLabel.font=[UIFont systemFontOfSize:self.fontOfSize];
            
            //label标签tag值
            textLabel.tag= + i + 100 * j;
            
            //每创建一个label在contenSize上加上一个label的宽度
            self.contentSize=CGSizeMake(self.contentSize.width+labelW, self.bounds.size.height);
            
            [self addSubview:labelBackGroundView];
            [self addSubview:textLabel];
            
        }
    }
    
}
@end
