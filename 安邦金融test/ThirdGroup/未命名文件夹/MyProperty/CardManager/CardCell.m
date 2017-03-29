//
//  CardCell.m 
//  LiCaiBang
//
//  Created by 支梦召 on 2017/1/6.
//  Copyright © 2017年 AnBang. All rights reserved.
//  银行卡列表

#import "CardCell.h"
#import "Masonry.h"

@implementation CardCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *ID = [NSString stringWithFormat:@"CardCell"];
    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell =[[CardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加Button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
//        [btn setImage:[UIImage imageNamed:self.imageStr] forState:UIControlStateNormal];
        [self addSubview:btn];
        
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(21);
            make.left.equalTo(self).with.offset(36);
            make.size.equalTo(CGSizeMake(70,70));
        }];
        
        //添加UILabel
        UILabel *nameLab = [[UILabel alloc]init];
        //自动换行
        nameLab.textColor = [UIColor colorWithHexString:@"#5F5F5F"];
        nameLab.font = [UIFont systemFontOfSize:22];
        nameLab.textAlignment = NSTextAlignmentCenter;
//        nameLab.text = self.nameStr;
        CGSize labSize = [nameLab textSizeWithFont:22 withMessage:nameLab.text];
        [self addSubview:nameLab];
        [nameLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn);
            make.left.equalTo(btn).with.offset(21);
            make.size.equalTo(labSize);
        }];
        
        //添加UILabel
        UILabel *numberLab = [[UILabel alloc]init];
        //自动换行
        numberLab.textColor = [UIColor colorWithHexString:@"#5F5F5F"];
        numberLab.font = [UIFont systemFontOfSize:18];
        numberLab.textAlignment = NSTextAlignmentCenter;
//        numberLab.text = self.numberStr;
        CGSize numberSize = [numberLab textSizeWithFont:18 withMessage:numberLab.text];
        [self addSubview:numberLab];
        [numberLab makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btn);
            make.left.equalTo(btn).with.offset(21);
            make.size.equalTo(numberSize);
        }];

    }
    return self;
}
@end
